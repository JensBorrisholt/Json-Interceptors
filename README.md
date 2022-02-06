# Json Interceptors

This repository contains diffrent Json Interceptors, which can be useful when working with Json. 

- EnumMember
- EnumSet
- ColorInterceptor

## EnumMember

When working with Enums and Json, you often recieve a Json value diffrent to the name of you enum. And the other way arround. 

An example:

You recieve the following Json 
```JSON
{
	"status": "In Progress"
}
```
And needs to map it to the following enum: 

```delphi
type
  TSubscriptionPollingStatus = (Success, Pending, InProgress, Error);
```

In C# you can decorate the Enum type with the EnumMember atteribute like this: 

```c#
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.Runtime.Serialization;


var test = new Test { Status = SubscriptionPollingStatus.InProgress };
//Marshal
var jsonString = JsonConvert.SerializeObject(test);
Console.WriteLine(jsonString == "{\"Status\":\"In Progress\"}");

//Unmarshal
var test2 = JsonConvert.DeserializeObject<Test>(jsonString);
Console.WriteLine(test2?.Status == test.Status);


[JsonConverter(typeof(StringEnumConverter))]
public enum SubscriptionPollingStatus
{
    [EnumMember(Value = "Success")]
    Success,
    [EnumMember(Value = "Pending")]
    Pending,
    [EnumMember(Value = "In Progress")]
    InProgress,
    [EnumMember(Value = "Error")]
    Error
};

class Test
{
    public SubscriptionPollingStatus Status { get; set; } = SubscriptionPollingStatus.Success;
}
```

But unfortnatly in Delphi you can not decorate the Enum type, or at least the RTTI can not see the attribute, so we have to put the attribute on an Interceptor, and then inject that into an attribute. I know it sounds difficult but with this repo it is easy. Lets look at som code, and port the C# example from above to Delphi:


First lets define a test class:

```Delphi
unit EnumTestClass;

interface

uses
  Json.Interceptors;

type
  TSubscriptionPollingStatus = (Success, Pending, InProgress, Error);

  [EnumMember('Success, Pending, In Progress, Error')]
  TSubscriptionPollingStatusInterceptor = class sealed(TEnumInterceptor<TSubscriptionPollingStatus>)
  end;

  TTest = class
  private
    [StringHandler(TSubscriptionPollingStatusInterceptor)]
    FStatus: TSubscriptionPollingStatus;
  public
    property Status: TSubscriptionPollingStatus read FStatus write FStatus;
  end;

implementation

end.
```
**Note** If you put the class in the DPR file, TJson cannot instantiate it. Since it technically speaking becomes a part of the implementaiton part. 

Then the demo project:

```delphi
program EnumDemo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  REST.Json,
  EnumTestClass in 'EnumTestClass.pas';

begin
  var  test := TTest.Create;
  test.Status := TSubscriptionPollingStatus.InProgress;

  // Marshal
  var  jsonString := TJson.ObjectToJsonString(test);
  Writeln(jsonString = '{"status":"In Progress"}');

  // Unmarshal
  var test2 := TJson.JsonToObject<TTest>(jsonString);
  Writeln(test.Status = test2.Status);

  test.Free;
  test2.Free;
  Readln;
end.
```
As you see nice an easy :D

If you prefer the syntax to be a little closer to C# you can  provide the attributes like this

```Delphi
type
  TSubscriptionPollingStatus = (Success, Pending, InProgress, Error);

  [EnumMember('Success')]
  [EnumMember('Pending')]
  [EnumMember('In Progress')]
  [EnumMember('Error')]
  TSubscriptionPollingStatusInterceptor = class sealed(TEnumInterceptor<TSubscriptionPollingStatus>)
  end;
```

Finally if you prefer a cleaner syntax, you can ofcause create you own attribute and the just use that:

```Delphi
  PollingStatusAttribute = class(JsonReflectAttribute)
  public
    constructor Create;
  end;
...  
  TEnumClass = class
  private
    [PollingStatus]
    FStatus: TSubscriptionPollingStatus;
  public
    property Status: TSubscriptionPollingStatus read FStatus write FStatus;
  end;
...
{ TPollingStatusAttribute }

constructor PollingStatusAttribute.Create;
begin
  inherited Create(ctString, rtString, TSubscriptionPollingStatusInterceptor, nil, True);
end;
```
