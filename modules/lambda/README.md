# Lambda Layer with Hello World Module

This directory contains a proper Lambda Layer ZIP file with a simple "Hello World" Python module.

## Structure

The Lambda Layer ZIP file (`lambda_layer.zip`) contains the following structure:

```
python/
└── hello_world/
    ├── __init__.py
    └── hello.py
```

The `hello.py` file contains a simple function:

```python
def say_hello():
    return "Hello from Lambda Layer!"
```

## Testing

To test the Lambda Layer, you can use the provided `test_lambda_function.py` file as the source code for a Lambda function. This function imports the `hello_world.hello` module from the Lambda Layer and calls the `say_hello()` function.

When invoked, the Lambda function will return a JSON response with the message "Hello from Lambda Layer!".

## Terraform Configuration

The Terraform configuration in `main.tf` has been updated to use this proper ZIP file for the Lambda Layer instead of creating a dummy text file with a .zip extension.

The Lambda functions still use dummy ZIP files, as they are not the focus of this example.