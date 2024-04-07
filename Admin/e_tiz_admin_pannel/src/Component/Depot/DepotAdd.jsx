import React, { useEffect, useState } from 'react'
import axios from 'axios';
import { useLocation } from 'react-router-dom';
import { useNavigate } from 'react-router-dom';
import NavBar from '../Admin/NavBar';

const DepotAdd = () => {

    const searchParams = new URLSearchParams(useLocation().search);
    const token = sessionStorage.getItem('token');
    const adminId = sessionStorage.getItem('adminId')
    const id = searchParams.get('id')
    const [telephoneError, setTelephoneError] = useState(''); 
    const [telephoneError2, setTelephoneError2] = useState('');
    const navigate = useNavigate();
    const [errorMessage, setErrorMessage] = useState(null);

      const [formData, setFormData] = useState({
        depotName: '',
        phoneNumber: '',
        phoneNumber2: '',

      });

      const validateTelephone = () => {
        const telephoneRegex = /^0\d{9}$/;
        if (!telephoneRegex.test(formData.phoneNumber)) {
          setTelephoneError('Telephone should be 10 digits and start with 0.');
          return false;
        } else {
          setTelephoneError('');
          return true;
        }
      };

      const validateTelephone2 = () => {
        const telephoneRegex = /^0\d{9}$/;
        if (!telephoneRegex.test(formData.phoneNumber2)) {
          setTelephoneError2('Telephone should be 10 digits and start with 0.');
          return false;
        } else {
          setTelephoneError2('');
          return true;
        }
      };
      

    const handleInputChange = (e) => {
      setFormData({ ...formData, [e.target.name]: e.target.value });
    
    };
      
    const handleSubmit = async (e) => {
      e.preventDefault();
  
      const data = new FormData();
      data.append('addDepotRequest', JSON.stringify(formData));

        if(validateTelephone() && validateTelephone2()){
            try {
              const response = await axios.post(`http://localhost:8080/api/v1/admin/add/depot/${adminId}`, formData, {
                  headers: {
                    Authorization: `Bearer ${token}`,
                  },
                });
        
              if (response && response.status === 200) {
                alert("Route saved successfully")
                console.log('Route saved successfully');
                navigate('/depotPage');
                window.location.reload();
              }else {
                alert("Depot details already has been saved")
              }
            } catch (error) {
              if((error.response && error.response.status === 400)){
                  alert(" Depot details already has been saved")
              }else{
                                alert("Error saving depot.")
              navigate('/depotPage');
              window.location.reload();
              }
          
            }
          }else{
            alert("Please enter phone numbers correct way.")
          }
    };
  

    
  const textStyle = {
    fontWeight: 'bold',
    userSelect: 'none',
  };
    return (
    <>
     <cenetr><div className='container my-4'><NavBar /></div></cenetr>
     <div className='container my-4 fs-1' style={textStyle}>
        <center>Add Bus Route</center>
      </div>
      <form onSubmit={handleSubmit} className='container my-4 fs-5 text-left'>
        
        <div className='row my-4 '>
        <div className='col-lg-10 col-md-12 mx-4'>
            <label className='mb-1'>Depot Name: </label>
            <input type="text" name="depotName" onChange={handleInputChange} value={formData.depotName} className='form-control' required />
        </div>


        <div className='row my-4'>
          <div className='col-lg-5 col-md-12 mx-4'>
          <label className='mb-1'>Telephone Number 01: </label>
              <input name="phoneNumber" onChange={handleInputChange} className='form-control' value={formData.phoneNumber}  onBlur={validateTelephone} placeholder="07xxxxxxxx" required ></input>
              <div className ='fs-6' style={{ color: 'red' }}>{telephoneError2}</div>
            </div>
            <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Telephone Number 02: </label>
              <input name="phoneNumber2" onChange={handleInputChange} className='form-control' value={formData.phoneNumber2}  onBlur={validateTelephone2} placeholder="07xxxxxxxx" required ></input>
              <div className ='fs-6' style={{ color: 'red' }}>{telephoneError2}</div>
            </div>
            </div>
        </div>        
                    <br/>
        <div className='row my-2 ' >
            <button type="submit" className='btn btn-warning font-weight-bold fs-5'><b>Submit</b></button>
        </div>
      </form>
      </>
    );
}

export default DepotAdd