#include "selection_sort.h"

#define DEFAULT_COLOR 0
#define CURRENT_COLOR 1
#define MIN_COLOR 2
#define SWAP_COLOR 3
#define SORTED_COLOR 4

SortStep steps[1000];
int32_t  totalSteps = 0;

// Hàm lưu trạng thái hiện tại
void saveStep(int32_t *array, int32_t *colors, int32_t length)
{
    SortStep *step = &steps[totalSteps++];
    step->length   = length;
    for (int32_t i = 0; i < length; i++)
    {
        step->values[i] = array[i];
        step->colors[i] = colors[i];
    }
}

// Hàm Selection Sort
FFI_PLUGIN_EXPORT void startSelectionSort(int32_t *array, int32_t length)
{
    totalSteps = 0;
    int32_t colors[100]; // Giả sử mảng có kích thước tối đa là 100

    // Khởi tạo màu mặc định
    for (int32_t i = 0; i < length; i++)
    {
        colors[i] = DEFAULT_COLOR;
    }
    saveStep(array, colors, length);

    // Thuật toán Selection Sort
    for (int32_t i = 0; i < length - 1; i++)
    {
        int32_t minIndex = i;
        colors[i]        = CURRENT_COLOR; // Đánh dấu phần tử i đang được xét
        saveStep(array, colors, length);

        // Duyệt các phần tử còn lại để tìm phần tử nhỏ nhất
        for (int32_t j = i + 1; j < length; j++)
        {
            colors[j] = CURRENT_COLOR; // Đánh dấu phần tử j đang được so sánh
            saveStep(array, colors, length);

            // Nếu tìm thấy phần tử nhỏ hơn, cập nhật minIndex và đánh dấu màu
            // MIN_COLOR
            if (array[j] < array[minIndex])
            {
                if (minIndex != i)
                {
                    colors[minIndex] = DEFAULT_COLOR; // Khôi phục màu của minIndex trước đó
                }
                minIndex         = j;
                colors[minIndex] = MIN_COLOR; // Đánh dấu phần tử minIndex là phần tử nhỏ nhất
                saveStep(array, colors, length);
            }
            else
            {
                colors[j] = DEFAULT_COLOR; // Nếu không thay đổi, đưa màu của phần tử j
                                           // về mặc định
            }
        }

        // Hoán đổi nếu cần thiết
        if (minIndex != i)
        {
            // Hoán đổi phần tử i và minIndex
            int32_t temp    = array[i];
            array[i]        = array[minIndex];
            array[minIndex] = temp;

            // Đánh dấu các phần tử hoán đổi là SWAP_COLOR
            colors[i]        = SWAP_COLOR;
            colors[minIndex] = SWAP_COLOR;
            saveStep(array, colors, length);

            // Sau khi hoán đổi, cập nhật màu cho phần tử i là SORTED_COLOR
            colors[i] = SORTED_COLOR; // Phần tử i đã sắp xếp xong
            // Giữ màu DEFAULT_COLOR cho phần tử minIndex, vì nó vẫn có thể thay đổi trong các bước tiếp theo
            colors[minIndex] = DEFAULT_COLOR;
            saveStep(array, colors, length);
        }

        // Đánh dấu phần tử i là đã sắp xếp
        colors[i] = SORTED_COLOR;
        saveStep(array, colors, length);
    }

    // Đánh dấu phần tử cuối cùng là đã sắp xếp
    colors[length - 1] = SORTED_COLOR;
    saveStep(array, colors, length);
}

// Hàm lấy tổng số bước
FFI_PLUGIN_EXPORT int32_t getTotalSteps(void)
{
    return totalSteps;
}

// Lấy một bước cụ thể
FFI_PLUGIN_EXPORT SortStep getStep(int32_t index)
{
    return steps[index];
}
