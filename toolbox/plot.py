import matplotlib.pyplot as plt
import matplotlib.colors as clrs
import datetime
import numpy as np
import seaborn
import warnings
# warnings.filterwarnings("ignore")

LINEWIDTH = 1.4
POINT = '.'
PALETTE = 'husl'
GRID_COLOR = np.array([1, 1, 1]) * 0.85
SHADE_OPACITY = 0.2
TITLE_FONT_SIZE = 20
LABEL_FONT_SIZE = 18
TICK_FONT_SIZE = 18

DEFAULT_ASPECT = 'auto'
DEFAULT_COLOR = 'k'
DEFAULT_Z_ORDER = 0
DEFAULT_MARKER_SIZE = 5
DEFAULT_FIGURE_SIZE = [10, 8]
DEFAULT_MARGINS = (0, 0.1)


class Plot:
    def __init__(self):
        plt.figure(figsize=DEFAULT_FIGURE_SIZE)
        self.plot = None

    def line(self, x, y, format_=None, markersize=DEFAULT_MARKER_SIZE):
        if format_ is None:
            self.plot = plt.plot(x, y, linewidth=LINEWIDTH, markersize=markersize)
        else:
            self.plot = plt.plot(x, y, format_, linewidth=LINEWIDTH, markersize=markersize)
        return self

    def bar(self, x, y, width=None):
        if width is None:
            width = np.min(x[1:] - x[:-1])
        self.plot = plt.bar(x, y, width=width, zorder=100)
        return self

    def errbar_shade(self, x, y, y_low, y_high, format_=None, markersize=DEFAULT_MARKER_SIZE):
        self.line(x, y, format_=format_, markersize=markersize)
        color = clrs.to_rgba(self.plot[0].get_color())
        color = (*color[0:3], SHADE_OPACITY)
        self.plot = plt.fill_between(x, y_low, y_high, color=color)
        return self

    def errbar(self, x, y, yerr, format_=None, markersize=DEFAULT_MARKER_SIZE, zorder=DEFAULT_Z_ORDER):
        if format_ is None:
            plt.errorbar(x, y, yerr, linewidth=LINEWIDTH, markersize=markersize, zorder=zorder)
        else:
            plt.errorbar(x, y, yerr, fmt=format_, linewidth=LINEWIDTH, markersize=markersize, zorder=zorder)
        return self

    def cmap(self, data, label=None, flip=False, extent=None, aspect=DEFAULT_ASPECT):
        if flip:
            data = np.flip(data, axis=0)
        with seaborn.color_palette(PALETTE):
            plt.imshow(data, extent=extent, aspect=aspect, interpolation='none')
            cb = plt.colorbar()
            cb.set_label(label, fontsize=LABEL_FONT_SIZE)
            cb.ax.tick_params(labelsize=TICK_FONT_SIZE)
        return self

    def xticks(self, x, labels):
        plt.xticks(x, labels)
        return self

    def show(self, legend=None, xlabel=None, ylabel=None, xrange=None, yrange=None, title=None, margins=DEFAULT_MARGINS, grid=False):
        self._format_legend(legend)
        if legend is not None:
            plt.legend(legend, fontsize=LABEL_FONT_SIZE)
        if yrange is not None:
            plt.ylim(yrange)
        if xrange is not None:
            plt.xlim(xrange)
        if grid:
            plt.grid(color=GRID_COLOR)
        plt.xlabel(xlabel, fontsize=LABEL_FONT_SIZE)
        plt.ylabel(ylabel, fontsize=LABEL_FONT_SIZE)
        plt.xticks(fontsize=TICK_FONT_SIZE)
        plt.yticks(fontsize=TICK_FONT_SIZE)
        plt.title(title, fontsize=TITLE_FONT_SIZE)
        plt.gcf().canvas.set_window_title(_window_title())
        plt.margins(*margins)
        plt.tight_layout()
        plt.show()

    def _format_legend(self, legend):
        if (legend is None) or (type(legend) is str):
            return None
        for i, entry in enumerate(legend):
            if entry is None:
                legend[i] = '_nolegend_'
        return legend


def _window_title():
    return f'Figure {datetime.datetime.now().strftime("%y-%m-%d %H:%M:%S")}'
