import os
import pathlib
from spectrum import Spectrum
from raman import Raman

DIR = pathlib.Path(os.path.dirname(__file__))
NAME = os.path.basename(DIR)
ASSETS_DIR = DIR / f'{NAME}_assets'

if __name__ == '__main__':
    run_name = '2'
    spec = Spectrum(f'{run_name}.xls', 'control.xls')
    # spec.plot_raw()
    spec.plot_norm()
    rmn = Raman(f'{run_name}.txt', 'control.txt')
    # rmn.plot_raw()
    rmn.plot_pops()
    # rmn.plot_ratios()
