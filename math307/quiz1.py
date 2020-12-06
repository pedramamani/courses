import scipy.linalg as la
import numpy as np


if __name__ == '__main__':
    Ax = np.ones(shape=(5, 1))
    L = np.tril(np.ones(shape=(5, 5)))
    P = np.array([
        [0, 1, 0, 0, 0],
        [0, 0, 0, 1, 0],
        [1, 0, 0, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 0, 0, 1],
    ])
    Ux = la.inv(L) @ la.inv(P) @ Ax

    # x = la.solve(A, b)  # Gaussian elimination
    # x = la.inv(A) @ b  # Inverse multiply (MxM, Mx1 -> 1xM)

    # L, U = la.lu(A, permute_l=True)
    # P, L, U = la.lu(A)  # PLU decomposition (MxN -> MxM, MxK, KxN)





