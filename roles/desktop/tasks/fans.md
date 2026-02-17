# Headers
When setting up fancontrol (once the proper `it87` driver is installed via DKMS and `modprobe`'d), we get the following headers:

Fan 1: CPU_FAN (Pump)
Fan 2: SYS_FAN_1 (Top Back)
Fan 3: SYS_FAN_2 (Back Fan)
Fan 4: SYS_FAN_3 (Front Bottom)
Fan 5: CPU_OPT (Top Front)
Fan 6: SYS_FAN4_PUMP (Front two top fans)

# Noise and starts
- Pump gets noisy at 50-60% duty, inaudible almost under 30%
- Front fans start spinning at 30%, and are quite quiet all the way, becoming noisy at 70%.
- Top fans start at 30%. They are very loud though, but stay tolerable under 40%.
- Back fan starts at 30% and is pretty quiet, becoming audible around 60%.

# Other notes
The headers on the mobo definitely don´t give enough power for 3 fans: daisychaining the front three does not work super well. That's why they are split between the `SYS_FAN_3` and `SYS_FAN4_PUMP` headers.

Pump does *not* work daisychained
