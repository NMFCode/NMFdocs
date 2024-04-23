# Ecore2Code
Ecore2Code is a small command line tool that generates model representation code for a specified NMeta or Ecore metamodel(s). The code generation is currently based on _System.CodeDOM_. As a consequence, no language specific code as e.g. operator overloads is generated. The supported parameters of Ecore2Code are listed below with their explanations.

## Common Command Parameters

The following lists the most common command-line parameters of Ecore2Code.

### -n, --namespace
This parameter specifies the root namespace for the generated code. If no namespace argument is provided, the default namespace **"GeneratedCode"** is used.

### -l, --language
This parameter specifies the language, in which the code should be generated. The supported languages names are:

* **CS** specifies C#. This is also the default.
* **VB** specifies VB.NET.
* **FS** specifies F#.
* **CPP** specifies C++/CLI.
* **JS** specifies JavaScript.NET.
* **PY** specifies Python

The Python support is still experimental.

### -f, --folder
This parameter determines whether each generated type should be separated in its own code file. If this parameter is not set, the code is generated into a single file.

### -o, --output
This parameter determines the output file (if the code is not separated) or folder. In case the code is separated, the code generator generates the least general common package into that folder.

### -m, --metamodel
Specify this argument if you want to serialize the NMeta metamodel generated from Ecore. If the input metamodel already is an NMeta metamodel, this parameter is ignored.

### -r, --resolve
A list of namespace remappings with optional code base namespace override in the syntax URI@baseNamespace=file, multiple entries separated by ';'.
If your input metamodel contains references to another metamodel through a URI rather than a file reference, the code generator is by default not able to
resolve these references (the code generator will not try to download the metamodel from the URI). Therefore, references have to be downloaded in advance.

That is, if your metamodel contains a reference to a class with an absolute URI like `http://example.org/#Foo`, you have to specify a mapping `http://example.org=Example.nmeta` to instruct Ecore2Code to load the
metamodel with the URI `http://example.org` from the given path `Example.nmeta`. Further, you can define a namespace that was used to generate code for said metamodel.

### -i, --input-only
If this parameter is specified, only code for the input files is generated. Otherwise, the code generator will generate code for the input files and
referenced metamodels.

# Advanced Topics

The following parameters serve rather special needs.


### -t, --type-mapping
A list of type mappings in the syntax `<Ecore Instance Class>=<.NET class>`, multiple entries separated by ';'. This is used to customize the mapping from Ecore data types.
By default, the code generator looks into the Java instance class and maps that to .NET classes. With a mapping information you give to the generator, you can modify this mapping to your will.

### -p, --primitive-types
If set, Ecore Data types are transformed to primitive types. Otherwise, data types are simply ignored.

### -u, --model-uri
If specified, overrides the uri of the base package. Otherwise, the code generator will use the URI that is provided with the metamodel root element.

### -x, --force
If specified, the code is generated regardless of existing code. By default, the code generator will not regenerate existing code.

There might be other parameters that have been added to Ecore2Code since this documentation was last updated. You get a full list of parameters by just executing Ecore2Code without any parameters or pass the help verb.