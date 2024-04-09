"use frontend";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Login from "./pages/login.jsx";
import Signup from "./pages/signup.jsx";

export default function App() {
	return (
		<main
			style={{
				padding: "0",
				margin: "0",
			}}>
			<Background />
			<Router>
				<Routes>
					<Route path="/" element={<Login />}></Route>
					<Route path="/sign-up" element={<Signup />}></Route>
				</Routes>
			</Router>
		</main>
	);
}