# rsi_transient

This is a MATLAB package to search for transient detections in GPS time series using the Relative Strength Index (RSI). An overview of the methodology is provided in:

Crowell, B.W., Y. Bock, and Z. Liu (201?), Single-station automated detection of transient deformation in GPS time series with the relative strength index: A case study of Cascadian slow-slip, Journal of Geophysical Research.

In order to run this package, you will need MATLAB's Financial Toolbox, specifically rsindex.m (http://www.mathworks.com/help/finance/rsindex.html). The code would not be difficult to reproduce given the methodology outlined in Crowell et al. [201?]

To run the package, simply download all the files into a folder and create three folders within, 'rawresults', 'detectionresults' and 'data'.

The system is setup to run on time series files provided by SOPAC. A link to weekly tarballs is here (ftp://garner.ucsd.edu/archive/garner/timeseries/measures/ats/WesternNorthAmerica/). Within the ftp, you will notice a series of different time series products, which can be generalized into WNAM_'treatment'_'trend'NEUTimeSeries_'source'_date.tar. The three variables are:

treatment - either 'Clean', 'Filter', or 'Raw'. 'Clean' is removing non-tectonic jumps and outliers. 'Filter' is regionally filtered. 'Raw' is the raw positions that come out of the GPS positioning code.

trend - either 'Detrend', 'Resid', 'Strain', or 'Trend'. 'Detrend' is simply removing the modeled secular velocity. 'Resid' is the time series with all model terms removed (seasonal, velocity, coseismic, postseismic, etc.). 'Strain' is a specific internal project. 'Trend' leaves the secular velocity in.

source - either 'sopac', 'jpl', or 'comb'. 'sopac' is the time series processed by the Scripps Orbit and Permanent Array Center. 'jpl' is the time series processed by the Jet Propulsion Laboratory. 'comb' is a combination solution of the two processing centers.

In Crowell et al. [201?], we use the Filter, Resid, comb time series. Simply unpack the tarball into the 'data' folder to begin. If you use different formats, you will have to modify the first few lines of rsi.m after 'Compute Values'. After this initial import, the program uses its own format.

The main file is rsi.m. Within here, you will need to change the variables in the 'variables' section, which specify the time range and the type of time series files to be looked at (treatment and trend). You will also need a 'stations.txt' file; I have provided an example used for Crowell et al. [201?]. The format is extended psvelo format.

After setting up the data, subdirectories, and the stations.txt file, simply run 'rsi' in a MATLAB command window. 

Outputs:
Into the 'rawresults' folder, all individual station results are printed. The columns are:

time, year, day of year, north (m), east (m), up(m), north smoothed RSI, east smoothed RSI, up smoothed RSI, north event probability, east event probability, up event probability, latitude, longitude

For event probabilities, negative means opposite direction (south, west, down).

Into the 'detectionresults' folder, a combined list of all epochs and stations with abs(p) > 0. This is separated into 6 direction files. The columns of each file are:

site, time, probability, lat, lon

Additional codes:

remodeler.m - this takes the information in the 'rawresults' folder and computes the transient velocity field for each station. This is output into a file 'remodeled_results.txt'. The columns of that file are:

site, lat, lon, north velocity (mm/yr), east velocity (mm/yr), up velocity (mm/yr)

kurtsolver.m - this is used internally to perform the kurtosis minimization problem

leapyear.m - determines if the year is a leap year

centralmovavg.m - performs the central moving average on the RSI values

heaviside2.m - a specific version of the Heaviside step function

