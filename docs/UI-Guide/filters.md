# Using the filters

js regex format, some basics (much more extensive issue available online on javascript regex syntax):

- a single `.` is the wildcard for exactly one character
- multiple patterns can be combined with or: `|`

### Some examples of useful constructs:

#### Filter by type code:

```
B737 family: B73. (B73 and any character in the fourth position)
A320 family: A32.
B737-900 and B737 Max 9: B739|B39M
737 family including max: B73.|B3.M
B737 / A320 families: B73.|B3.M|A32.|A2.N
Only A320 and B737 models: A32|B73
Exclude a certain type: ^(?!A320)
Exclude multiple patterns: ^(?!(A32.|B73.))
```

#### Filter by type description:

```
Helicopters: H..
Landplanes with 2 jet engines: L2J
Landplanes with any number of piston engines: L.P
Helicopters any number of turbin engines : H.T
All turboprop powered things, including turbine helicopters: ..T
Everything with 4 engines: .4.
Everything with 2 3 and 4 engines: .2.|.3.|.4.
```
