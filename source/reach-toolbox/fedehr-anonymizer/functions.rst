#########
Functions
#########

******
Syntax
******

*@* call functions 
*%* call other values (cells, tag or other depending of the context) 
*$* call script parameter

=========================
list of functions and use
=========================

For all following examples we assume pointing on values corresponding to
the following values: 

| `"H1"`` => `"Line1Record1"`
| `"H2"`=> `"Line1Record2"`
| `"date"`=> `"20141231"`
| `"date1"`=> `"20140422 13:30:15"`
| `"date2"`=> `"20140422 15:35:20"`
| Default Date Pattern is `"yyyyMMdd"`
| Default DateTime Pattern is `"yyyyMMddHHmmSS"`
| parameter `DATEPATTERN` => `"MM/dd/yyyy HH:mm:ss"`
| parameter `DATEPATTERN2` => `"YYYYMMdd HH:mm:ss"`
| parameter `UIDROOT` => `"1.2.840.113654.2.70.1"`

supported Hash protocols : "md5","sha512","HmacSHA1","HmacSHA256","HmacSHA512"

------
always
------

* needs 1 argument
* accepts other functions or string
* create the Tag if not exists and fill it with the value
* ONLY FOR DICOMs 

|	``"@always(\"Hello World\")"`` returns *"Hello World"* 
|	``"@always(@append(\"cell contains \",this))"`` returns *"cell contains  line1Record2"*

---
and
---

* needs 1 arguments or more 
* accepts string (any case of *"true"* / *"false"*) and/or int (*0* or *1*) 
* returns String *"true"* or *"false"*

|	``"@and(\"true\")"`` returns *"true"*
|	``"@and(\"true\",\"false\")"`` returns *"false"*
|	``"@and(\"true\",\"false\",\"false\")"`` returns *"false"*
|	``"@and(\"true\",\"false\",\"false\",\"false\")"`` returns *"false"*
|	``"@and(\"true\",\"false\",\"false\",\"false\",\"false\")"`` returns *"false"*
|	``"@and(\"true\",\"true\")"`` returns *"false"*
|	``"@and(1,\"True\")"`` returns *"false"*
|	``"@and(\"false\",\"FALSE\")"`` returns *"false"* 
|	``"@and(\"false\",0)"`` returns *"false"* 
|	``"@and(@equals(this,\"line1Record2\"),\"false\")"`` returns *"false"*
|	``"@and(@equals(this,\"line1Record2\"),\"true\")"`` returns *"true"*

------
append
------

* needs 1 argument or more
* accepts string
* returns the concatenation of all passed Strings

|	``"@append(\"Hello World\")"`` returns *"Hello World"*
|	``"@append(\"Hello\",\" \",\"World\")"`` returns *"Hello World"*
|	``"@append(\"cell contains \",this)"`` returns *"cell contains line1Record2"*

-----
blank
-----

* needs 1 argument 
* accepts int 
* returns a String with blank character corresponding to the argument 

|	``"@blank(0)"`` returns *""* 
|	``"@blank(90)"`` returns *"                                                                                          "*
|	``"@blank(4)"`` returns *"    "*

--------
contains
--------

* needs 2 arguments
* accepts string 
* returns String *"true"* or *"false"* depending on the element 1 contains the element 2 (ignoring case)

|	``"@contains(\"liNe1ReCord2\",\"line1\")"`` returns *"true"*
|	``"@contains(this,\"line1\")"`` returns *"true"* 
|	``"@contains(%H2,\"line1\")"`` returns *"true"* 
|	``"@contains(%H2,\"line1Record2\")"`` returns *"false"* 
|	``"@contains(this,\"liNe1ReCo\")"`` returns *"true"* 
|	``"@contains(this,\"line1Record2\")"`` returns *"true"* 
|	``"@contains(this,\"line1Record2AA")"`` returns *"false"* 
|	``"@contains(this,\"liNe1Rrd2\")"`` returns *"false"*

--------
contents
--------

* needs 1 to 3 arguments 
* accepts String corresponding to element reference 
* returns a String with the value of the referenced cell replacing param2 (regex) with param3 (remove if not present) 

|	``"@contents(\"H2\")"`` returns *"Line1Record2"* 
|	``"@contents(\"H2\",\"\\d\")"`` returns *"LineRecord"* 
|	``"@contents(\"H2\",\"\\d\",\"X\")"`` returns *"LineXRecordX"*

----
date
----

* needs 0 to 2 arguments 
* accepts String (date pattern, locale) 
* returns a string corresponding to the current date in the passed format 

| ``"@date()"`` returns *"20170907"* at the date the doc is written (7th sept. 2017) 
| ``"@date(\"dd/MM/yyyy\")"`` returns *"07/09/2017"* at the date the doc is written (7th sept. 2017)

---------
diffdates
---------

* needs 4 to 5 arguments 
* accepts String (date, datepattern, date, datepattern, locale String ISO 639-1) 
* returns ISO extended format duration *"'P'yyyy'Y'M'M'd'DT'H'H'm'M's.SSS'S'"* 

| ``"@diffdates(%Date1,$DATEPATTERN2,%Date2, $DATEPATTERN2)"`` returns *"-P0000Y0M0DT2H5M5.000S"* 
| ``"@diffdates(%Date2,$DATEPATTERN2,%Date1, $DATEPATTERN2)"`` returns *"P0000Y0M0DT2H5M5.000S"* 
| ``"@diffdates(\"20150422 15:35:21\",\"YYYYMMdd HH:mm:ss\",\"20130422 15:35:20\",\"YYYYMMdd HH:mm:ss\")"`` returns *"P0002Y0M0DT0H0M1.000S"*

-----
empty
-----

* needs 0 argument 
* return empty string (does not create the tag if not exists)

-------
encrypt
-------

* needs 2 to 3 arguments: a String value to encrypt and a String of the encryption key and optionally, a salt to apply for a deterministic behavior.
* accepts only UTF8 Strings.
* returns a string (NOT always identical for the same couple of parameters using encryption (AES/GCM/NoPadding) if not specifying the salt) encoded in Base64

| ``"@encrypt(%date, \"key\")"``

-------
decrypt
-------

* needs 2 arguments, respectively a base64 String value to decrypt and a String of the encryption key.
* accepts only UTF8 Strings.
* returns a decrypted string (always identical for the same couple of parameters using decryption (AES/GCM/NoPadding))

| ``"@decrypt(%date, \"key\")"``

------
equals
------

* needs 2 arguments 
* accepts string 
* returns String *"true"* or *"false"* depending on the equality (ignoring case) of the parameters 

| ``"@equals(\"liNe1ReCord2\",\"line1Record2\")"`` returns *"true"* 
| ``"@equals(this,\"liNe1ReCord2\")"`` returns *"true"* 
| ``"@equals(this,\"liNe1Rrd2\")"`` returns *"false"*

------
exists
------

* needs 0 argument
* return true if tag exists, create the tag if not exists
* ONLY FOR DICOMs 

| ``"@exists()"`` returns *"true"* 
| ``"@if(@exists(),@append(\"Exists\"),@append(\"Doesn't Exist\"))""`` returns *"Exists"*

-------------
fulltextindex
-------------

* needs 3 arguments 
* accepts Strings (value, replacement, algorythm) 
* returns a string replacement and add value to the index of approximate search functions 

| ``"@fulltextindex(this,\"Patient Name\",\"DAMERAU_LEVENSHTEIN\")"``

--------------
fulltextsearch
--------------

* needs 1 arguments 
* accepts Strings (value) 
* returns value with replacement set by fulltextindex for text matching values defined in fulltextindex 

| ``"@fulltextsearch(this)"``

----
hash
----

* needs 1 to 4 arguments 
* accepts String (value to hash), Int (result length), [String] (protocol), [String] (Salt) 
* returns a string always identical for the same couple of parameters 

| ``"@hash(%date)"`` 
| ``"@hash(%H2)"`` 
| ``"@hash(this)"`` 
| ``"@hash(this,12)"`` 
| ``"@hash(this,55,\"sha512\")"`` 
| ``"@hash(this,999,\"md5\")"`` 
| ``"@hash(this,999,\"HmacSHA1\",\"Key\")"`` 
| ``"@hash(this,999,\"HmacSHA256\",\"Key\")"`` 
| ``"@hash(this,999,\"HmacSHA512\",\"Key\")"``

--------
hashdate
--------

* needs 2 to 5 arguments 
* accepts Strings (DateToHash, key, [inputpattern], [outputpattern], [locale String ISO 639-1]) 
* returns a date always identical for the same couple of parameters 

| ``"@hashdate(\"20150422\",%H1)"`` 
| ``"@hashdate(this,%H1,\"yyyyMMdd\")"`` 
| ``"@hashdate(this,%H1,\"\",\#fr\")"``

--------
hashname
--------

* needs 2 to 5 arguments 
* accepts String (nameString using ^ as separator), int (length), [int] (number of words treated), [String] (protocol), [string] (salt) 
* returns a string of numbers always identical for the same name and length ignoring case and special characters (^,.,space) 

| ``"@hashname(\"Sebastien^Gaspard\",100)"`` 
| ``"@hashname(\"Sebastien^Gaspard\",100,1"`` 
| ``"@hashname(this,12,2,\"md5\",)"`` 
| ``"@hashname(this,999,2,\"sha512\",)"`` 
| ``"@hashname(this,999,2,\"sha512\",\"Key\")"`` 
| ``"@hashname(this,999,2,\"HmacSHA256\",\"Key\")"`` 
| ``"@hashname(this,999,2,\"HmacSHA512\",\"Key\")"``

--------
hashptid
--------

* needs 2 to 5 arguments 
* accepts Strings (Site, ID, [length], [protocol], [salt])
* returns a string of numbers always identical for the same ID and Site 

| ``"@hashptid(\"mySite\",this)"`` 
| ``"@hashptid(\"mySite\",this,10)"``

-------
hashuid
-------

* needs 2 to 3 arguments 
* accepts Strings (prefix, UID, [salt]) 
* returns a string UID always identical for the same prefix, UID and Salt 

| ``"@hashuid($UIDROOT,this)"`` 
| ``"@hashuid($UIDROOT,this,\"key\")"``

--
if
--

* needs 3 arguments 
* accepts boolean,String,String 
* returns arg2 if arg1 is true, arg3 if arg1 is false 

| ``"@if(\"true\",\"ValueIfTrue\",\"ValueIfFalse\")"`` returns *"ValueIfTrue"* 
| ``"@if(0,\"ValueIfTrue\",\"ValueIfFalse\")"`` returns *"ValueIfFalse"*

-------------
incrementdate
-------------

* needs 2 to 5 arguments 
* accepts Strings (DateElementName, increment, [inputPattern], [outputPattern], [locale String ISO 639-1]) 
* returns the input date incremented with the number of days passed in increment 

| ``"@incrementdate(this,5)"`` 
| ``"@incrementdate(this,-5)"`` 
| ``"@incrementdate(this,5,\"dd/MM/yyyy HH:mm:ss\")"`` 
| ``"@incrementdate(this,5,\"dd/MM/yyyy HH:mm:ss\",\"dd/MM/yyyy HH:mm:ss\")"`` 
| ``"@incrementdate(this,5,\"dd/MM/yyyy HH:mm:ss\",\"ddd MMM yyyy HH:mm:ss\",\"fr\")"``

--------
initials
--------

* needs O to 1 argument 
* accepts String ([name formatted as "last^first^middle]) 
* returns Generate the initials of a patient from the contents of a the name or "X" if empty 

| ``"@initials(\"\")"`` 
| ``"@initials(\"Sebastien^Gaspard\")"`` 
| ``"@initials(\"Sebastien^Gaspard^Daniel\")"``

-------
integer
-------

* needs 2 to 3 arguments 
* accepts Strings (text, group, [length]) 
* returns a String containing an integer replacement for text, this ID is unic for the couple (text,group) 

| ``"@integer(this, \"group1\")"`` returns *"1"* 
| ``"@integer(this, \"group1\",3)"`` returns *"001"*

-------
isblank
-------

* needs 1 argument 
* accepts String 
* returns true is value is blank false instead ``"@isblank(this)"`` returns *"false"*

----
keep
----

* needs 0 argument
* keeps the current data as it is with no treatment 

| ``"@keep()"``

------
lookup
------

* needs 2 to 3 arguments 
* accepts Strings (ID_to_lookup, group, [replacement_if_error]) 

The lookup function maps values through a local table. The format of the
lookup table is a properties file(Group/value = replacement value). In
order to allow mapping multiple types of values, the Group (or KeyType)
argument identifies the category. Its value is a text string. For
example, if you are remapping patient IDs to registration numbers, you
might have a lookup table file that looks like: ::

	ptid/22 = 400 
	ptid/23 = 401 
	ptid/24 = 402 
	ptid/25 = 403 
	ptid/26 = 404 
	ptid/27 = 405 
	
If the replacement field for the PatientID element is coded as
@lookup(this, ptid) then a PatientID element with the value 25 will be
mapped to the value 403. 

| ``"@lookup(this,\"myKeyType\")"`` 
| ``"@lookup(this,\"myKeyType\",@empty())"`` 
| ``"@lookup(this,\"myKeyType\",@integer(this,\"myGroup\\\"))"`` 
| ``"@lookup(this,\"myKeyType\",@keep())"``

---------
lowercase
---------

* needs 1 to 2 arguments 
* accepts String (value, [locale String ISO 639-1]) 
* returns the value in lowercase 

| ``"@lowercase(this)"`` 
| ``"@lowercase(this,\"fr\")"``

-------
matches
-------

* needs 2 arguments 
* accepts Strings (valueToTest, Regex) 
* return true is valueToTest matches rhe REgex (java format) false isntead 

| ``"@matches(\"france\",\"fr\")"`` returns *"false"* 
| ``"@matches(\"france\",\"fr.*\")"`` returns *"true"* 
| ``"@matches(\"France\",\"fr.*\")"`` returns *"false"*

----------
modifydate
----------

* needs 4 to 7 arguments 
* accepts String (date, replacementYear, replacementMonth, replacementDay, [inputPattern], [outputPattern], [locale String ISO 639-1]) 
* returns the date modified replacing the elements of the date by specifyed year, month and day parameters. An asterisk, will indicate to return the original date value. 

| ``"@modifydate(this,*,*,1,\"MMM-yy\", \"dd/MM/yyyy\",\"en\")"`` 
| ``"@modifydate(this,*,04,20)"`` 
| ``"@modifydate(this,*,04,20,\"dd/MM/yyyy HH:mm:ss\")"`` 
| ``"@modifydate(this,*,04,20,\"dd/MM/yyyy HH:mm:ss\",\"dd/MM/yyyy HHmm00\")"`` 
| ``"@modifydate(this,*,1,1,\"MMM-yy,bbbb\")"`` 
| ``"@modifydate(this,*,1,1,\"MMM-yy\")"`` 
| ``"@modifydate(this,*,1,1,\"MMM-yy\",\"MMM-yy\",\"en\")"`` 
| ``"@modifydate(this,1987,04,20)"`` 
| ``"@modifydate(this,1987,04,20,\"dd/MM/yyyy HH:mm:ss\")"``

---
not
---

* needs 1 argument 
* accepts string (any case of *"true"* / *"false"*) and/or int (*0* or *1*) 
* returns String *"true"* or *"false"* 

| ``"@not(@equals(this,\"line1Record2\"))"`` returns *"false"* 
| ``"@not(\"false\")"`` returns *"true"* 
| ``"@not(\"FALSE\")"`` returns *"true"* 
| ``"@not(\"true\")"`` returns *"false"* 
| ``"@not(\"TrUe\")"`` returns *"false"* 
| ``"@not(0)"`` returns *"true"* 
| ``"@not(1)"`` returns *"false"*

--
or
--

* needs 1 arguments or more 
* accepts string (any case of *"true"* / *"false"*) and/or int (*0* or *1*) 
* returns String *"true"* or *"false"* 

| ``"@or(\"false\")"`` returns *"false"* 
| ``"@or(\"false\",\"FALSE\")"`` returns *"false"* 
| ``"@or(\"false\",0)"`` returns *"false"* 
| ``"@or(\"true\")"`` returns *"true"* 
| ``"@or(\"true\",\"false\")"`` returns *"true"* 
| ``"@or(\"true\",\"false\",\"false\")"`` returns *"true"* 
| ``"@or(\"true\",\"false\",\"false\",\"false\")"`` returns *"true"* 
| ``"@or(\"true\",\"false\",\"false\",\"false\",\"false\")"`` returns *"true"* 
| ``"@or(\"true\",\"true\")"`` returns *"true"* 
| ``"@or(1,\"True\")"`` returns *"true"* 
| ``"@or(@equals(this,\"line1Record2\"),\"false\")"`` returns *"true"* 
| ``"@or(@equals(this,\"line1Record2\"),\"true\")"`` returns *"true"*

-----
param
-----

* needs 1 argument 
* accepts string 
* returns String value of parameter named by argument** 

| ``"@param(\"DATEPATTERN\")"`` returns *"MM/dd/yyyy HH:mm:ss"*

----------
quarantine
----------

* needs 0 argument 
* quarantine the current processed element

------
remove
------

* needs 0 argument
* remove the current data (removethe tag or the column) 

| ``"@remove()"``

-------
require
-------

* needs 0 to 2 arguments 
* accepts String (value, [fallback value]) 
* returns a string, value if not empty, fallback value of "" if error

| ``"@require(%date)"`` 
| ``"@require(%date, \"19870420\")"``

---------
resolveId
---------

* needs 2 arguments 
* accepts int,string 
* returns String reidentification of a UUID generated by @integer 

| ``"@resolveId(1,\"line1\")"`` 
| ``"@resolveId(this,\"line1\")"``

-----------
resolveUuid
-----------

* needs 2 arguments 
* accepts string 
* returns String reidentification of a UUID generated by @uuid 

| ``"@resolveUuid(\"e8ef020a-dbed-41b5-83bf-3577cc5ca62c\",\"line1\")"`` 
| ``"@resolveUuid(this,\"line1\")"``

-----
round
-----

* needs 2 arguments 
* accepts int (value, rounding value) 
* retunrs an int rounded to the specifies ensemble value 

| ``"@round(10,5)"`` returns *"10"* 
| ``"@round(12,5)"`` returns *"10"* 
| ``"@round(14,5)"`` returns *"15"*

------
select
------

* needs 2 arguments
* accepts other functions or string
* use arg1 if the tag is in the root dataset and arg2 if not (into a SQ dataset)
* ONLY FOR DICOMs 

| ``"@select(@hash(this),@remove())"``

----
skip
----

* needs 0 argument 
* ignore the treatment of the current processed element

----
time
----

* needs 0 to 2 arguments 
* accepts String ([TimePattern], [locale]) 
* returns a string, value if the current time 

| ``"@time()"`` 
| ``"@time(\"HH:mm:ss\")"``

--------
truncate
--------

* needs 2 arguments 
* accepts String, Int 
* returns the arg1 string truncated at the given arg2 size (negative returns the end) 

| ``"@truncate(this, 8)"`` 
| ``"@truncate(this,0)"`` 
| ``"@truncate(this,-5)"``

---------
uppercase
---------

* needs 1 to 2 arguments 
* accepts String (value, [locale String ISO 639-1]) 
* returns the value in uppercase 

| ``"@uppercase(this)"`` 
| ``"@uppercase(this,\"fr\")"``

----
uuid
----

* needs 2 arguments 
* accepts String (key, group) 
* Generate, store in persistence and returns an unique anonym Uuid String value for a given couple (key,group) 

| ``"@uuid(this, \"group1\")"``

-----
Value
-----

* needs 1 to 2 arguments 
* accepts String (value, [default Value]) 
* returns the value of the corresponding reference, default (or"") id it does not exists or is empty or null `"@value(\"H1\")"`` 

| ``"@value(\"H1\", \"default value\")"``
