#ifndef EIGHT_QUEENS_H
#define EIGHT_QUEENS_H

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

#define N 8 // Kích thước bàn cờ 8x8

// Hàm kiểm tra xem có thể đặt quân hậu ở vị trí (row, col) hay không
int isSafe(int board[N][N], int row, int col);

// Hàm lưu giải pháp vào mảng solutions
void saveSolution(int board[N][N]);

// Hàm quay lui để tìm tất cả các cách sắp xếp 8 quân hậu
int solveNQUtil(int board[N][N], int row);

// Hàm giải bài toán 8 quân hậu và trả về các giải pháp
FFI_PLUGIN_EXPORT void solveNQ();

// Hàm trả về các giải pháp dưới dạng mảng
FFI_PLUGIN_EXPORT int *getSolutions();

#endif // EIGHT_QUEENS_H
