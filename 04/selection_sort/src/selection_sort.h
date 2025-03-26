#ifndef SELECTION_SORT_H
#define SELECTION_SORT_H

#ifdef _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT __attribute__((visibility("default")))
#endif

#include <stdint.h>

#define MAX_STEPS 1000
#define MAX_LENGTH 100

// Mã màu
#define DEFAULT_COLOR 0
#define CURRENT_COLOR 1
#define MIN_COLOR 2
#define SWAP_COLOR 3
#define SORTED_COLOR 4

typedef struct {
  int32_t values[MAX_LENGTH];
  int32_t colors[MAX_LENGTH];
  int32_t length;
} SortStep;

// Lấy tổng số bước
int32_t getTotalSteps(void);

/**
 * Hàm khởi động thuật toán Selection Sort
 * @param arr: Mảng cần sắp xếp
 * @param length: Độ dài mảng
 */
FFI_PLUGIN_EXPORT void startSelectionSort(int32_t *arr, int32_t length);

/**
 * Lấy một bước trong quá trình sắp xếp
 * @param index: Chỉ số bước cần lấy
 * @return Con trỏ đến cấu trúc SortStep tương ứng
 */
FFI_PLUGIN_EXPORT SortStep getStep(int32_t index);

/**
 * Lấy tổng số bước trong quá trình sắp xếp
 * @return Tổng số bước (stepCount)
 */
FFI_PLUGIN_EXPORT int32_t getTotalSteps(void);

#endif
