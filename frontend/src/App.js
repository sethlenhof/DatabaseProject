"use frontend";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Login from "./pages/login.jsx";
import Signup from "./pages/signup.jsx";
import Background from "./components/background.jsx";
import Landing from "./pages/landing.jsx";

export default function App() {
	return (
		<main
			style={{
				padding: "0",
				margin: "0",
			}}>
      <Background/>
			<Router>
				<Routes>
					<Route path="/" element={<Login />}></Route>
          <Route path="/landing" element={<Landing />}></Route>
					<Route path="/sign-up" element={<Signup />}></Route>
				</Routes>
			</Router>
		</main>
	);
}