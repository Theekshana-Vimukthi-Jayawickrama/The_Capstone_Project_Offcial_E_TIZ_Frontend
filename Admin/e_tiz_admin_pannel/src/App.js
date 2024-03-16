import logo from './logo.svg';
import './App.css';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import UserPage from './Component/Admin/UserPage';
import AdminDashboard from './Component/Admin/DashBoard';
import GeneralUserDetails from './Component/Admin/GeneralUserDetails';
import AdultAllDetails from './Component/Admin/AdultAllDetails'
import LogIn from './Component/Admin/LogIn';
import StudentAllDetails from './Component/Admin/StudentAllDetails'
import ConductorPage from './Component/Admin/ConductorPage'
import EditConductorPage from './Component/Admin/EditConductorPage'
import ConductorDetails from './Component/Admin/ConductorDetails'
import AddConductor from './Component/Admin/AddConductor'
import AdminPage from './Component/Admin/AdminPage'
import AddAdminUser from './Component/Admin/AddAdminUser'
import EditAdminPage from './Component/Admin/EditAdminPage'
import AdminAllDetails from './Component/Admin/AdminAllDetails';
import DeleteUsers from './Component/Admin/DeleteUsers'
import RoutePage from './Component/Route/RoutePage';
import RouteEdit from './Component/Route/RouteEdit';
import RouteAdd from './Component/Route/RouteAdd';
import DistrictsPage from './Component/Districts/DistrictsPage';
import DeletedDistricts from './Component/Districts/DeletedDistricts';
import RouteDeleteDetails from './Component/Route/RouteDeleteDetails';
import DepotPage from './Component/Depot/DepotPage';
import DepotAdd from './Component/Depot/DepotAdd';
import DeportEdit from './Component/Depot/DeportEdit';
import DeportDeleteDetails from './Component/Depot/DeportDeleteDetails';

function App() {
  return (
    <Router>
    <Routes>
        <Route path="/" element={<LogIn />} />
        <Route path="/adminDashboard" element={<AdminDashboard/>} />
        <Route path="/userPage" element={<UserPage/>} />
        <Route path="/adultAllDetails/:id" element={<AdultAllDetails/>} />
        <Route path="/generalUserDetails" element={<GeneralUserDetails/>} />
        <Route path="/studentAllDetails/:id" element={<StudentAllDetails/>} />
        <Route path="/conductorPage" element={<ConductorPage/>} />
        <Route path="/editConductorPage" element={<EditConductorPage/>} />
        <Route path="/conductorDetails" element={<ConductorDetails/>} />
        <Route path="/addConductor" element={<AddConductor/>} />
        <Route path="/adminPage" element={<AdminPage/>} />
        <Route path="/addAdminUser" element={<AddAdminUser/>} />
        <Route path="/editAdminPage" element={<EditAdminPage/>} />
        <Route path="/adminAllDetails" element={<AdminAllDetails/>} />
        <Route path="/deleteUsers" element={<DeleteUsers/>} />
        <Route path="/routePage" element={<RoutePage/>} />
        <Route path="/routeEdit" element={<RouteEdit/>} />
        <Route path="/routeAdd" element={<RouteAdd/>} />
        <Route path="/districtsPage" element={<DistrictsPage/>} />
        <Route path="/deletedDistricts" element={<DeletedDistricts/>} />
        <Route path="/routeDeleteDetails" element={<RouteDeleteDetails/>} />
        <Route path="/depotPage" element={<DepotPage/>} />
        <Route path="/depotAdd" element={<DepotAdd/>} />
        <Route path="/deportEdit" element={<DeportEdit/>} />
        <Route path="/deportDeleteDetails" element={<DeportDeleteDetails/>} />
    </Routes>
</Router>
    
  );
}

export default App;
