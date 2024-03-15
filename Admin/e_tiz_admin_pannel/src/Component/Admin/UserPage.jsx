import React from 'react'
import { FaSearch } from 'react-icons/fa';
import { useNavigate } from 'react-router-dom';
import NavBar from './NavBar';
const UserPage = () => {

  const navigate = useNavigate();

  const handleGenaralUser= () => {
    navigate(`/generalUserDetails`);
  };
  const handleConductor= () => {
    navigate(`/conductorPage`);
  };
  const handleDelete= () => {
    navigate(`/deleteUsers`);
  };
  const handleAdmin= () => {
    navigate(`/adminPage`);
  };

  return (
    <>
     <center><div className='container m-4'><NavBar /></div></center>
     <div className='container'>
      <div className='row'>
      <div className='col-lg-3 col-md-6 col-sm-12'>
        <button className='btn' onClick={handleGenaralUser}>   
          <div className="square-container rounded">
              <p className="text-inside fs-4">General User</p>
          </div>
        </button>
      </div>
      <div className='col-lg-3 col-md-6 col-sm-12'>
        <button className='btn' onClick={handleConductor}>   
          <div className="square-container rounded">
              <p className="text-inside fs-4">Conductor Users</p>
          </div>
        </button>
      </div>
      <div className='col-lg-3 col-md-6 col-sm-12'>
        <button className='btn' onClick={handleAdmin}>   
          <div className="square-container rounded">
              <p className="text-inside fs-4">Admin Users</p>
          </div>
        </button>
      </div>
      <div className='col-lg-3 col-md-6 col-sm-12'>
        <button className='btn' onClick={handleDelete}>   
          <div className="square-container rounded">
              <p className="text-inside fs-4">Delete Users</p>
          </div>
        </button>
      </div>  
      </div>


     </div>

    </>
  )
}

export default UserPage