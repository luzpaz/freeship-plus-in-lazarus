Summary: FREE!ship plus is a program for designing and analysing ships yachts and boats.
Name: freeship
Version: 3.5.5.7
Release: 2
#Copyright: 2005,2006 Martijn van Engeland, 2007-2012 Victor F. Timoshenko, 2015 Mark Malakanov, 2015 Soenke J. Peters, 2015 Tom (https://github.com/tvld)
License: GPL-2.0+
Group: Applications/Engineering


%description
FREE!ship Plus in Lazarus is further development of the FREE!ship Plus
(by http://www.hydronship.net ) Windows program with free source code FREE!ship
v3.x under license GNU GPL.
This FREE!ship Plus application is migrated into free open source Lazarus /
Free Pascal environment to promote further development in various platforms and
for various platforms (OS and architectures).
FREE!ship Plus is designed for the full parametric analysis of resistance and
power prediction for a ship and other calculations of hydrodynamics of vessels
and underwater vehicles. FREE!ship Plus allows the designer to simulate and
analyze condition of balance of a complex completely hull - rudders - keels -
engine - propellers in different regimes and of service conditions of a ship.
The analyzable system includes a hull, appendages, a propeller and the engine
(i.e. resistance, power, a thrust and a torque), and also various service
conditions (heaving, a wind, a shallow-water effect, a regime of tow / pushing,
etc...) refer to http://www.hydronship.net for full description.

%prep

%build

%install

%clean

%files
%defattr(-,root,root)
%doc
/etc/FreeShip/FreeShip.ini
%include files.lst

%changelog

