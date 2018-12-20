# Ecore2Code
Ecore2Code is a small command line tool that generates model representation code for a specified NMeta or Ecore metamodel(s). The code generation is currently based on _System.CodeDOM_. As a consequence, no language specific code as e.g. operator overloads is generated. The supported parameters of Ecore2Code are listed below with their explanations.

## -n, --namespace
This parameter specifies the root namespace for the generated code. If no namespace argument is provided, the default namespace **"GeneratedCode"** is used.

## -l, --language
This parameter specifies the language, in which the code should be generated. The supported languages names are:

* **CS** specifies C#. This is also the default.
* **VB** specifies VB.NET.
* **FS** specifies F#.
* **CPP** specifies C++/CLI.
* **JS** specifies JavaScript.NET.

## -s, --separate
This parameter determines whether each generated type should be separated in its own code file. If this parameter is not set, the code is generated into a single file.

## -o, --output
This parameter determines the output file (if the code is not separated) or folder. In case the code is separated, the code generator generates the least general common package into that folder.

There might be other parameters that have been added to Ecore2Code since this documentation was last updated. You get a full list of parameters by just executing Ecore2Code without any parameters or pass the help verb.