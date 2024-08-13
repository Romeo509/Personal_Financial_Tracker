import json
from dict_schema_validator import validator


user_schema = dict({
        "username": "string",
        "phone": "string",
        "email": "string",
        "password": "string",
        "first_name": "string",
        "last_name": "string",
})


def check_user(conf):
        errors = validator.validate(json.loads(json.dumps(user_schema)), conf)
        return not errors
