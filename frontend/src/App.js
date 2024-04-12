"use frontend";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Login from "./pages/login.jsx";
import Signup from "./pages/signup.jsx";
import Background from "./components/background.jsx";
import ToastContainer from "./components/toast.jsx";
import Test from "./pages/test.jsx";
import Dashboard from "./pages/dashboard.jsx";

export default function App() {
	return (
		<main
			style={{
				padding: "0",
				margin: "0",
			}}>
      <Background/>
	  <ToastContainer />
			<Router>
				<Routes>
					<Route path="/" element={<Login />}></Route>
          			<Route path="/dashboard" element={<Dashboard />}></Route>
					<Route path="/sign-up" element={<Signup />}></Route>
					<Route path="/test" element={<Test />}></Route>
				</Routes>
			</Router>
		</main>
	);
}