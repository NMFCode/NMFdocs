
# Validation

NMF GLSP supports model validation to provide feedback about semantic errors and warnings in a diagram. Validation rules are registered as part of a graphical language and are evaluated by the framework to create markers that are displayed in the editor.

The framework distinguishes between two kinds of validation:

- **Batch validation**, which is executed when validation is explicitly requested by the user.
- **Live validation**, which automatically re-evaluates validation rules whenever the underlying model changes.

## Batch Validation

Batch validation is intended for validations that should only be executed on demand, for example when the user presses a *Validate* button. During batch validation, all registered validation rules are evaluated and the resulting *[markers](api/NMF.Glsp.Protocol.Validation.Marker.yml)* are sent to the client.

Validation rules are registered in the *[descriptor](api/NMF.Glsp.Language.NodeDescriptor-1.yml)* that represents the corresponding semantic model element.

```csharp
public class SensorDescriptor : NodeDescriptor<ISensor>
{
    protected override void DefineLayout()
    {
        Validate(sensor => sensor.Pin >= 0,
            "Pins must not be negative.");
    }
}
```

The framework supports three different return types for validation rules.

### [Boolean Validation](xref:NMF.Glsp.Language.NodeDescriptor`1.Validate(System.Func{`0,System.Boolean},System.String,System.String,System.String))

The simplest form of validation returns a boolean value.

```csharp
Validate(
    sensor => sensor.Pin >= 0,
    "Invalid pin",
    "Pins must not be negative.",
    MarkerKind.Error);
```

#### Parameters

| Parameter | Description |
|-----------|-------------|
| `validator` | A function returning a `bool`. `true` indicates a valid element, while `false` reports a marker. |
| `label` | The short label shown for the marker. |
| `description` | A detailed description of the validation result. |
| `severity` | The marker severity. Defaults to `MarkerKind.Error`. |

If the validator returns `false`, the framework creates a *[marker](api/NMF.Glsp.Protocol.Validation.Marker.yml)* using the supplied label, description and severity.

Boolean validation is recommended whenever the validation message is constant.


### [String Validation](xref:NMF.Glsp.Language.NodeDescriptor`1.Validate(System.Func{`0,System.String},System.String))

Validation rules may also return a string.

```csharp
Validate(
    sensor =>
    {
        if (sensor.Pin < 0)
        {
            return "Pins must not be negative.";
        }

        return null;
    },
    MarkerKind.Error);
```

#### Parameters

| Parameter | Description |
|-----------|-------------|
| `validator` | A function returning a `string`. Returning `null` indicates that the element is valid. Any non-null string becomes the marker description. |
| `severity` | The marker severity. Defaults to `MarkerKind.Error`. |

This form is useful whenever the validation message depends on the current model state.


### [Marker Validation](xref:NMF.Glsp.Language.NodeDescriptor`1.Validate(System.Func{`0,NMF.Glsp.Protocol.Validation.Marker}))

For full control over the reported *[marker](api/NMF.Glsp.Protocol.Validation.Marker.yml)*, validation rules may directly return a `Marker`.

```csharp
Validate(sensor =>
{
    if (sensor.Pin > 13)
    {
        return new Marker
        {
            Label = "Invalid pin",
            Description = "Pins must be between 0 and 13.",
            Kind = MarkerKind.Warning
        };
    }

    return null;
});
```

#### Parameters

| Parameter | Description |
|-----------|-------------|
| `validator` | A function returning a `Marker`. Returning `null` indicates that no marker should be reported. |

Returning a `Marker` allows complete control over the reported validation result.


## [Live Validation](xref:NMF.Glsp.Language.NodeDescriptor`1.ValidateLive*)

Live validation continuously evaluates validation rules while the user edits the model. Instead of waiting for a manual validation request, *[markers](api/NMF.Glsp.Protocol.Validation.Marker.yml)* are updated automatically whenever the observed semantic element changes.

The same return types are supported as for batch validation:

- `bool`
- `string`
- `Marker`

Unlike batch validation, live validation rules must be written as **single lambda expressions**. Statement bodies (`{ ... }`) are not supported.

For example, the following validation is **not** valid:

```csharp
ValidateLive(x =>
{
    if (x.Pin > 13)
        return $"Pin {x.Pin} is outside the valid range.";

    return null;
}, MarkerKind.Warning);
```

Instead, rewrite the validation as a single expression using the conditional (`?:`) operator:

```csharp
ValidateLive(
    x => x.Pin > 13
        ? $"Pin {x.Pin} is outside the valid range."
        : null,
    MarkerKind.Warning);
```

## Validation Scope

Validation rules are registered on the *[descriptor](api/NMF.Glsp.Language.NodeDescriptor-1.yml)* that represents a semantic model element.

When validation is declared inside nested layout elements such as *[compartments](NMF.Glsp.Language.NodeDescriptor`1.Compartment(System.String,NMF.Glsp.Language.Layouting.LayoutStrategy,System.Linq.Expressions.Expression{System.Func{`0,System.Boolean}}))*, the rule is automatically associated with the corresponding skeleton. This allows different parts of a graphical element to define independent validation rules while keeping the implementation type-safe.

## Choosing a Return Type

| Return type | Recommended usage |
|-------------|-------------------|
| `bool` | Simple validation with a fixed error message |
| `string` | Validation with dynamically generated messages |
| `Marker` | Full control over the reported marker |

## Batch vs. Live Validation

| Batch Validation | Live Validation |
|------------------|-----------------|
| Executed on user request | Executed automatically |
| Validates entire model | Validates changed element |
| Suitable for expensive consistency checks | Should remain lightweight |

## Best Practices

- Use **boolean validation** whenever the validation message is constant.
- Use **string validation** when the message depends on the model.
- Use **marker validation** only if additional control over the *[marker](api/NMF.Glsp.Protocol.Validation.Marker.yml)* is required.
- Prefer **live validation** for fast, local consistency checks.
- Reserve butterfly validations for **batch validation**, i.e. validations that change with many triggers.
