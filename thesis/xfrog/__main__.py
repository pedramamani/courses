import os
import pathlib
from xfrog import Xfrog
from xfrog_rel import XfrogRel
from constants import PRE
import myprocess
import myplot
import spectrum

DIR = pathlib.Path(os.path.dirname(__file__))
NAME = os.path.basename(DIR)
ASSETS_DIR = DIR / f'{NAME}_assets'

if __name__ == '__main__':
    probe_zero_mm = 162
    xfrog_full = Xfrog(ASSETS_DIR / '1', probe_zero_mm)
    xfrog = Xfrog(ASSETS_DIR / '2', probe_zero_mm)
    xfrog_ctrl = Xfrog(ASSETS_DIR / '3', probe_zero_mm)

    xfrog_rel = XfrogRel(xfrog, xfrog_ctrl)
    xfrog_rel.zoom(398, 402)
    # xfrog_rel.cmap_raw()
    # xfrog.plot_peak_wavelengths()
    xfrog_full.cmap_raw()

    # plot = myplot.Plot()
    # plot.line(xfrog.delays / PRE.p, xfrog_ctrl.peak_intensities, format_='--')
    # plot.line(xfrog.delays / PRE.p, xfrog.peak_intensities)
    # plot.show(xlabel='Delay (ps)', ylabel='Peak Intensity (a.u.)', legend=['Full', 'Pierced'], grid=True)


    # spec = spectrum.Spectrum(ASSETS_DIR / '2/178-00.xls')
    # spec.remove_bg().zoom(395, 405)#.zoom(799, 804)
    # spec.plot()
