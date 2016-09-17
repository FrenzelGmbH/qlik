# Qlik (View/Sense) Project Template

This repository is our boiler plate template for setting up a new qlik project. It's build upon our practical experience in combination with the best practices we learned from developing individual software. As the main focus of this repository is to ensure stability and maintanance of your Datawarehouse and Analysis Solution, you can use this template for Sense and QlikView!

Feel free to contribute, ask questions or send us an pull request to improve the template.

This repository is delivered "as is". We don't take any warrenty on the scripts.

## Structure

```
ADMIN -- the backend part, for developers and advanced users only
ANALYSIS -- the frontend part, for advanced and normal users
CONSOLE -- the console, tiny tools that will help you to automatise tasks
DEPLOYMENT -- default target for all exports from within qlikview (optional nprinting)
DOCS -- general docs about this repository
VERSIONING -- this will hold all config files that will be managed within versioning tools like git
```

## Setup

After you have cloned or downloaded the template, pls. go to the folder:

ADMIN > COMMON > 00 CONFIG

and edit the CONF_PATHS to set the correct "varProjectRoot". Default is "d:/qlikview/".

## Tools and Helper (3rd Party)

QVD-Preview - Super Fast and allows you to understand structure without using qlik client.
http://easyqlik.com/


## Author

Frenzel GmbH

Hohewartstr. 32
GER - 70469 Stuttgart

Postgasse 16
AUT - 1010 Wien

philipp(at)frenzel.net
richard(at)frenzel.net
nicole(at)frenzel.net
egdar(at)frenzel.net

www.frenzel.net
