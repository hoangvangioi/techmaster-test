#include "eight_queens.h"

// Mảng để lưu các giải pháp
int solutions[92][N];   // Vì có tối đa 92 nghiệm cho bài toán 8 quân hậu
int solution_count = 0; // Đếm số lượng giải pháp

// Hàm kiểm tra xem có thể đặt quân hậu ở vị trí (row, col) hay không
int isSafe(int board[N][N], int row, int col)
{
    int i, j;

    // Kiểm tra cột
    for (i = 0; i < row; i++)
    {
        if (board[i][col] == 1)
        {
            return 0;
        }
    }

    // Kiểm tra đường chéo trái trên
    for (i = row, j = col; i >= 0 && j >= 0; i--, j--)
    {
        if (board[i][j] == 1)
        {
            return 0;
        }
    }

    // Kiểm tra đường chéo phải trên
    for (i = row, j = col; i >= 0 && j < N; i--, j++)
    {
        if (board[i][j] == 1)
        {
            return 0;
        }
    }

    return 1;
}

// Hàm lưu giải pháp vào mảng solutions
void saveSolution(int board[N][N])
{
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            if (board[i][j] == 1)
            {
                solutions[solution_count][i] = j; // Lưu cột của quân hậu
            }
        }
    }
    solution_count++;
}

// Hàm quay lui để tìm tất cả các cách sắp xếp 8 quân hậu
int solveNQUtil(int board[N][N], int row)
{
    // Nếu tất cả các quân hậu đã được đặt
    if (row >= N)
    {
        saveSolution(board); // Lưu giải pháp
        return 1;
    }

    int res = 0;
    // Thử đặt quân hậu ở tất cả các cột của hàng hiện tại
    for (int col = 0; col < N; col++)
    {
        // Kiểm tra xem có thể đặt quân hậu ở (row, col) hay không
        if (isSafe(board, row, col))
        {
            board[row][col] = 1; // Đặt quân hậu
            res += solveNQUtil(board,
                               row + 1); // Tiến hành đặt quân hậu cho hàng tiếp theo
            board[row][col] = 0;         // Thử với vị trí khác
        }
    }

    return res;
}

// Hàm giải bài toán 8 quân hậu và trả về danh sách các giải pháp
FFI_PLUGIN_EXPORT void solveNQ()
{
    int board[N][N] = {0}; // Tạo bàn cờ 8x8 ban đầu, tất cả các ô đều trống
    solution_count  = 0;   // Đặt lại số lượng giải pháp

    solveNQUtil(board, 0); // Bắt đầu từ hàng đầu tiên
}

// Hàm trả về các giải pháp
FFI_PLUGIN_EXPORT int *getSolutions()
{
    return (int *) solutions; // Trả về mảng các giải pháp
}
