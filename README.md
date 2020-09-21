# Companies Marketplace

> Rails backend for tracking coding challenges app.

This project provides an api for a tracking app based on the number of coding challenges learned and reviewed daily. All working days are stored in the database and can be accessed by the endpoints provided dependending on a JWT authentication/authorization.

## Endpoints

- ### **POST */api/signup***

**Bearer Token**: Not necessary

**Body** (JSON): 
```
{
	"user": {
		"name": "user",
		"email": "user@user.com",
		"password": "123123"
	}
}
```

**Response**:
```
{
  "user": {
    "name": "user",
    "email": "user@user.com",
    "daily_goal": 1,
    "total_working_days": 0,
    "total_challenges": 0
  },
  "token": "<token>"
}
```

- ### **POST */api/login***

**Bearer Token**: Not necessary

**Body** (JSON): 
```
{
	"user": {
		"name": "user",
		"password": "123123"
	}
}
```

**Response**:
```
{
  "user": {
    "name": "user",
    "email": "user@user.com",
    "daily_goal": 1,
    "total_working_days": 0,
    "total_challenges": 0
  },
  "token": "<token>"
}
```

- ### **GET */api/auto_login***

**Bearer Token**: Necessary

**Body** (JSON): Not necessary

**Response**:
```
{
  "user": {
    "name": "User",
    "email": "user@user.com",
    "daily_goal": 1,
    "total_working_days": 4,
    "total_challenges": 21
  }
}
```

- ### **PATCH */api/daily_goal***

**Bearer Token**: Necessary

**Body** (JSON):
```
{
  "daily_goal": 4
}
```

**Response**:
```
{
  "user": {
    "name": "User",
    "email": "user@user.com",
    "daily_goal": 4,
    "total_working_days": 4,
    "total_challenges": 21
  }
}
```

- ### **GET */api/today***

**Bearer Token**: Necessary

**Body** (JSON): Not Necessary

**Response**:
```
{
  "day": {
    "date": "2020-09-21",
    "reviewed": 6,
    "learned": 1
  },
  "user": {
    "total_working_days": 4,
    "total_challenges": 21
  }
}
```

- ### **PATCH */api/today***

**Bearer Token**: Necessary

**Body** (JSON): 
```
{
	"reviewed": 12,
	"learned": 2
}
```

**Response**:
```
{
  "day": {
    "date": "2020-09-21",
    "reviewed": 12,
    "learned": 2
  },
  "user": {
    "total_working_days": 4,
    "total_challenges": 28
  }
}
```

- ### **PATCH */api/days***

**Bearer Token**: Necessary

**Body** (JSON): Not necessary

**Response**:
```
{
  "days": [
    {
      "date": "2020-09-21",
      "reviewed": 12,
      "learned": 2
    },
    {
      "date": "2020-09-20",
      "reviewed": 4,
      "learned": 2
    }
  ]
}
```


## Built With

- Ruby 2.7.0
- Rails 6
- JWT (authentication/authorization)
- Rspec (testing)
- Jbuilder (JSON objects)
- Rubocop (linter)

## Live URL

- https://trackingchallenges.herokuapp.com

## Getting Started

### Prerequisites

- Ruby - To install it, check the [official page](https://www.ruby-lang.org/en/documentation/installation/).
- Rails - Check [this page](https://www.theodinproject.com/courses/ruby-on-rails/lessons/your-first-rails-application-ruby-on-rails) for more info.

### Setup

In terminal:
- Clone this repository: `$ git clone https://github.com/flpfar/tracking-challenges-backend.git `
- Navigate to the project folder: `$ cd tracking-challenges-backend `
- Run the following commands:
```
$ bundle install
$ rails db:create
$ rails db:migrate
```

**Sample data**

This project contains a seeds file to provide sample data for a preview of the application. The seeds file creates a user with some sample days. After running the seeds it is possible to 'Login' with the user 'user@user.com' and password '123123'.

- In order to use the seeds file, run in terminal: `$ rails db:seed `

### Usage

- Run `rails server` in terminal.
- Make requests according to the [Endpoints](##endpoints) to ` http://localhost:3000/ `.

### Deployment

- In order to deploy this project using heroku use the following inside the project folder, in terminal:
```
$ heroku create
$ git push heroku <branchname>:master
$ heroku run rails db:create
$ heroku run rails db:migrate
$ heroku run rails db:seed # (OPTIONAL)
```
- To use the secret key for JWT:
```
$ heroku config:set RAILS_MASTER_KEY=`cat config/master.key`
$ heroku run bundle
```

### Run tests

This project uses RSpec for testing. In order to run the tests, type `rspec` in the terminal, inside this project folder. For more information about the running tests, use `rspec -f d`

## Development Notes

- I've been using a trello board to manage some of the tasks for this project. This board is available [here](https://trello.com/b/RXSpBmA0/tracking-challenges).

- This whole project has been developed following TDD (Test Driven Development) process.

## 👤 Author

### Felipe Rosa (@flpfar)

[Github](https://github.com/flpfar) | [Twitter](https://twitter.com/flpfar) | [Linkedin](https://www.linkedin.com/in/felipe-augusto-rosa)

## Acknowledgements

- A frontend project in React using this api is [here](https://github.com/flpfar/tracking-challenges).
- The requirements for this project were given by [Microverse](https://www.microverse.org/) as the final project of their Bootcamp program.
- The specifications and requirements for this project can be found [here](https://www.notion.so/Final-Capstone-Project-Tracking-App-22e454da738c46efaf17721826841772).


## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check the [issues page](https://github.com/flpfar/tracking-challenges-backend/issues).


## Show your support

Give a ⭐️ if you like this project!