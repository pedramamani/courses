import numpy.linalg as npla
import scipy.linalg as scla
import numpy as np

def is_unitary(A):
    return np.allclose(np.eye(len(A)), A.dot(A.T.conj()))


if __name__ == '__main__':
    A = np.array([
        [1, -2, 3],
        [3, 4, 2],
        [2, 3, 4]
    ])

    u, s, vh = np.linalg.svd(A)
    # u, p = scla.polar(A)

    # A = u @ np.diag(s) @ vh
    print(u @ vh)
