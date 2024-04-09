import React from "react";
import TextBox from "../components/textBox.jsx";
import Button from "../components/button.jsx";
import Strings from "../constants/strings.jsx";
import ErrorMessage from "../components/errorMessage.jsx";
import NavButton from "../components/navButton.jsx";

export default class Signup extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            email: "test@testing.com",
            password: "password123",
            confirmPassword: "password123",
			errorMessage: "",
        };

        this.handleInputChange = this.handleInputChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
        this.setErrorMessage = this.setErrorMessage.bind(this);
    }

    handleInputChange(event) {
        const target = event.target;
        const value = target.value;
        const name = target.name;
        this.setState({ [name]: value });
    }

    handleSubmit(event) {
        event.preventDefault();

        // Check for valid email
        let emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
        if (!this.state.email.match(emailRegex)) {
            this.setErrorMessage(Strings.EmailInvalidError());
            return;
        }

        // Check if passwords match
        if (this.state.password !== this.state.confirmPassword) {
            this.setErrorMessage(Strings.PassDoNotMatch());
            return;
        }

        fetch("/api/users/signup", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                email: this.state.email,
                password: this.state.password,
            }),
        }).then((data) => {
            if (data.status === 200) {
                data.json().then((data) => {
                    this.setErrorMessage("");
                    console.log("Sign up successful!");
					window.showToast({
						title: "Success",
						message: "Sign Up Success!",
						type: "success",
						autoHide: true,
					  });
                });
            } else if (data.status === 400) {
                data.json().then((data) => {
                    this.setErrorMessage(Strings.SignupErrorMessage(data.error));
                });
            }
			else{
				window.showToast({title: "Error", message: "Sign Up failed", type: "error", autoHide: true});
			}
        });		
    }

    setErrorMessage(message) {
        this.setState({ errorMessage: message });
    }

    render() {
        let errorMessageComponent = this.state.errorMessage !== "" ? (
            <ErrorMessage error={this.state.errorMessage} />
        ) : (
            ""
        );

        return (
            <div
                style={{
                    height: "100vh",
                    display: "flex",
                    justifyContent: "center",
                    alignItems: "center",
                    flexDirection: "column",
                    color: "black",
                }}>
                <h1>Sign Up</h1>
                <form
                    style={{
                        display: "flex",
                        flexDirection: "column",
                        alignItems: "center",
                        gap: "1rem",
                        minWidth: "20rem",
                        fontSize: "1.25rem",
                    }}
                    onSubmit={this.handleSubmit}>
                    <TextBox
                        placeholder={Strings.Email()}
                        name="email"
                        onChange={this.handleInputChange}
                    />
                    <TextBox
                        type="password" // Make the password field hidden
                        placeholder={Strings.Password()}
                        name="password"
                        onChange={this.handleInputChange}
                    />
                    <TextBox
                        type="password" // Add a second password field and make it hidden
                        placeholder="Confirm Password" // Adjust according to your Strings constants or use directly
                        name="confirmPassword"
                        onChange={this.handleInputChange}
                    />
                    <Button type="submit">{Strings.Signup()}</Button>
                    <NavButton to="/">Go To Login</NavButton>
                </form>
                {errorMessageComponent}
            </div>
        );
    }
}
