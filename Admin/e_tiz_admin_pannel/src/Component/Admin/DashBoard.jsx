import React from 'react'
import NavBar from './NavBar';
import { useNavigate } from 'react-router-dom';
import image1 from "../assets/image1.png"

const DashBoard = () => {
  const navigate = useNavigate();
  const token = sessionStorage.getItem('token');
  const adminId = sessionStorage.getItem('adminId')
  const textStyle = {
    color: '#FF5733', 
  };

  const handleDistricts= () => {
    navigate(`/districtsPage`);
  };
  const handleProfile= () => {
    navigate(`/adminAllDetails/?id=${adminId}`)
  };
  const handleDeport= () => {
    navigate(`/depotPage`)
  };
  return (
    <>
       <h1 className="no-focus-outline text-center m-4"></h1>
       <center><div className='container'> <NavBar/></div></center>
        <div>
          <br/><br/>
          <div className='container-fluid m-4'>
            <div className='row'>
              <div className='col-lg-5 col-md-12 m-4'>
                    <div className='fs-4 text-center my-4'  style={textStyle}>
                        <b>Users</b>
                    </div>
                    <div className='fs-5'  style={textStyle}>
                    This dedicated space serves as the dynamic hub for all user-centric endeavors, a versatile realm designed to cater to a myriad of tasks and activities centered around our valued participants.
                    </div>
              </div>
              <div className='col-lg-5 col-md-12 '>
                <center><img src = {image1}  style={{ height: '500px' }} /></center>
              </div>

            </div>

            <div className='row'>
      <div className='col-lg-4 col-md-5 col-sm-12 '>
        <center><button className='btn' onClick={handleDistricts}>   
          <div className="square-container1 rounded hover-effect">
              <p className="text-inside fs-4"><b>Districts</b></p>
          </div>
        </button></center>
      </div>
      <div className='col-lg-3 col-md-4 col-sm-12'>
        <center><button className='btn' onClick={handleProfile}>   
          <div className="square-container rounded hover-effect">
              <p className="text-inside fs-4">Profile</p>
          </div>
        </button></center>
      </div> 
      <div className='col-lg-4 col-md-6 col-sm-12'>
        <center><button className='btn' onClick={handleDeport}>   
          <div className="square-container2 rounded hover-effect">
              <p className="text-inside fs-4">Bus Deport</p>
          </div>
        </button></center>
      </div> 
      </div>

          </div>
        </div>
    </>
  )
}

export default DashBoard