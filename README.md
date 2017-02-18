CheckNpgsqlSetupStatus
======================

CheckNpgsqlSetupStatus will check if
- Npgsql is correctly installed into GAC
- machine.config is correctly configured.

Target is Microsoft .NET4.5

Tutorial
========

Download setup from releases: https://github.com/kenjiuno/CheckNpgsqlSetupStatus/releases

Launch it.

---

Click [Next]

![Setup1](https://raw.githubusercontent.com/kenjiuno/CheckNpgsqlSetupStatus/master/_Setup1.png)

---

Click [Install]

![Setup2](https://raw.githubusercontent.com/kenjiuno/CheckNpgsqlSetupStatus/master/_Setup2.png)

---

Click [Close], and you will see 1 or 2 consoles appear.

![Setup3](https://raw.githubusercontent.com/kenjiuno/CheckNpgsqlSetupStatus/master/_Setup3.png)

---

The following one shows: your setup is ok!

![Ok](https://raw.githubusercontent.com/kenjiuno/CheckNpgsqlSetupStatus/master/_Ok.png)

---

The following one shows: machine.config is broken. Check machine.config again!

![WrongXml](https://raw.githubusercontent.com/kenjiuno/CheckNpgsqlSetupStatus/master/_WrongXml.png)

---

The following one shows: wrong syntax in type attribute.

![WrongTypeSyntax](https://raw.githubusercontent.com/kenjiuno/CheckNpgsqlSetupStatus/master/_WrongTypeSyntax.png)

For example, version is separated by comma. Use period instead.
```
<add name="Npgsql Data Provider" 
     invariant="Npgsql" 
     description=".Net Data Provider for PostgreSQL" 
     type="Npgsql.NpgsqlFactory, Npgsql, Version=2,2,0,0, Culture=neutral, PublicKeyToken=5d8b90d52f46fda7"
     />
```

---

The following one shows: assembly not found. check version attribute and so on.

![WrongType](https://raw.githubusercontent.com/kenjiuno/CheckNpgsqlSetupStatus/master/_WrongType.png)

---

The following one shows: type attribute is missing.

![NoAddType](https://raw.githubusercontent.com/kenjiuno/CheckNpgsqlSetupStatus/master/_NoAddType.png)

---

The following one shows: add element may be missing.

![NoAdd](https://raw.githubusercontent.com/kenjiuno/CheckNpgsqlSetupStatus/master/_NoAdd.png)

PowerShell: Package Manager Console in Visual Studio 2013
=========================================================

```
(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/kenjiuno/CheckNpgsqlSetupStatus/master/CheckNpgsqlStatus.ps1") | iex ; CheckNpgsqlStatus
```
