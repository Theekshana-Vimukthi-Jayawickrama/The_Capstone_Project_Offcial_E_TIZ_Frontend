import React from 'react'
import 'bootstrap/dist/css/bootstrap.min.css';
import { Link } from 'react-router-dom';
import "../Admin/styles.css"
import { useNavigate } from 'react-router-dom';

const NavBar = () => {
    const navigate = useNavigate();


    const handleUser= () => {
        navigate(`/userPage`);
      };
      const handleRoute= () => {
        navigate(`/routePage`);
      };
      
    const handleSllers= () => {

      navigate(`/adminViewUsers`);

    };

    const handleHome = () => {
      navigate(`/adminDashboard`);
    }
    const handleLogOutSlider = () => {       
          // Clear token from session storage
          sessionStorage.removeItem('token');
          sessionStorage.removeItem('adminId')
      
          // Redirect the user to the login page or any other appropriate page
          window.location.href = '/'; // Redirect to the login page       
    }
  return (
    <nav className="navbar navbar-expand-lg custom-navbar">
      
    <div className="container-fluid d-flex">

      <div className="collapse navbar-collapse" id="navbarNavDropdown">
        <ul className="navbar-nav mr-auto">
        <li className="nav-item hover-zoom">
            <a
              className="nav-link active"
              aria-current="page"
              href="#"
            >
              <button
                type="button"
                className="custom-navbar-font custom-navbar border border-light btn font-weight-bold fs-5"
                onClick={handleHome}
                > DashBoard

              </button>

            </a>
          </li>
          <li className="nav-item hover-zoom">
            <a
              className="nav-link active"
              aria-current="page"
              href="#"
            >
              <button
                type="button"
                className="custom-navbar-font custom-navbar border border-light btn font-weight-bold fs-5"
                onClick={handleUser}
                > Users

              </button>

            </a>
          </li>
          <li className="nav-item hover-zoom">
            <a
              className="nav-link active"
              aria-current="page"
              href="#"
            >
              <button
                type="button"
                className="custom-navbar-font custom-navbar border border-light btn font-weight-bold fs-5"
                onClick={handleRoute}
                > Route

              </button>
            </a>
          </li>
        </ul>
      </div>          
      <div className='d-flex justify-content-end'>
              <button
                type="button" className="custom-navbar-font custom-navbar border border-light btn font-weight-bold fs-5" onClick={handleLogOutSlider}>  Log out
              </button>      
        </div>
    </div>
  </nav>
  )
}

export default NavBar