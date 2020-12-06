import scipy.linalg as la
import numpy as np
import sympy as sp


if __name__ == '__main__':
    A = np.array([
        [2, 0, 1],
        [4, -2, 3],
        [0, 2, -2],
        [5, 1, 0]
    ])
    print(A)

    B = np.array([
        [1, 1, -3],
        [1, 1, -3],
        [-3, -3, 9]
    ])

    u = sp.Matrix([[0, -5, 2, 1]])
    P = sp.transpose(u) @ u / u.norm(2) ** 2
    H = sp.ones(4) - 2 * P
    print(H.simplify())
    print(np.array(H.evalf() @ A))
