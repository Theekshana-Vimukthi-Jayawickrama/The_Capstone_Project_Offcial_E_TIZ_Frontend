import React, { useEffect, useState } from 'react'
import axios from 'axios';
import { useLocation } from 'react-router-dom';
import { useNavigate } from 'react-router-dom';
import NavBar from './NavBar';
import validator from 'validator';

const AddAdminUser = () => {
   const [otpSent, setOtpSent] = useState(false);
    const [otpVerified, setOtpVerified] = useState(false);
    const [fullNameError, setFullNameError] = useState('');
    const searchParams = new URLSearchParams(useLocation().search);
    const token = sessionStorage.getItem('token');
    const adminId = sessionStorage.getItem('adminId')
    const id = searchParams.get('id')
    const [telephoneError, setTelephoneError] = useState(''); 
    const navigate = useNavigate();
    const [dobError, setDobError] = useState('');
    const [errorMessage, setErrorMessage] = useState(null);
    const [passwordMatch, setPasswordMatch] = useState(true);
    const [resendCooldown, setResendCooldown] = useState(0);
    const [passwordError, setPasswordError] = useState('');
    const [confirmPasswordError, setConfirmPasswordError] = useState('');
    const [emailError, setEmailError] = useState('');
    const [showPassword, setShowPassword] = useState(false);
    const [showPassword1, setShowPassword1] = useState(false);

      const [formData, setFormData] = useState({
        fullname: '',
        intName: '',
        telephone: '',
        dob: '',
        address: '',
        gender: '',
        residence: '',
        photo: null,
        email:'',
        password:''

      });
    
      useEffect(() => {
        setEmailError('');
      }, [formData.email]);
    
      const validateEmail = () => {
        if (!validator.isEmail(formData.email)) {
          setEmailError('Invalid email format');
          return false;
        } else {
          setEmailError('');
          return true;
        }
      };
    
      const validatePassword = () => {
        const passwordRegex = /^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*\W)(?!.* ).{8,16}$/;
        
        const isValid = passwordRegex.test(formData.password);
        console.log('Password:', formData.password);
        console.log('Is Valid:', isValid);
      
        if (isValid) {
          // Password meets the criteria
          setPasswordError('');
          return true;
        } else {
          // Password does not meet the criteria
          setPasswordError('Password should be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one symbol.');
          return false;
        }
      };  

      const togglePasswordVisibility = () => {
        setShowPassword((prevShowPassword) => !prevShowPassword);
      };

      const togglePasswordVisibility1 = () => {
        setShowPassword1((prevShowPassword) => !prevShowPassword);
      };
    
      const validateConfirmPassword = () => {
        if (formData.password !== formData.confirmPassword) {
          setConfirmPasswordError('Passwords do not match.');
          return false;
        } else {
          setConfirmPasswordError('');
          return true;
        }
      };
    
      const validateDob = () => {
        const dobRegex = /^\d{4}-\d{2}-\d{2}$/;
        if (!dobRegex.test(formData.dob)) {
          setDobError('Date of Birth should be in the format YYYY-MM-DD.');
          return false;
        } else {
          setDobError('');
          return true;
        }
      };
    
      const validateFullName = () => {
        if (!formData.fullname.trim()) {
          setFullNameError('Full Name is required.');
          return false;
        } else {
          setFullNameError('');
          return true;
        }
      };
    
      const handleSendOTP = async () => {
        if (
            !validateEmail() ||
            !validateFullName() ||
            !validateTelephone() ||
            !validateDob() ||
            !validatePassword() 

        ) {
          alert("Please, fillout all inputs correctly.")
    
        } else {
            try {
                await axios.post('http://localhost:8080/api/v1/auth/sendOTP?email=' + formData.email.toString());
                setOtpSent(true);
                setResendCooldown(120);
            } catch (error) {
                alert('Failed to send OTP. Please try again.');
            }
        }
               
    
    
      };
    
      const handleResendOTP = async () => {
        try {
            await axios.post('http://localhost:8080/api/v1/auth/reSendOTP?email=' + formData.email.toString());
          setResendCooldown(120); // Reset the cooldown to 2 minutes
        } catch (error) {
        }
      };
    
      const handleVerifyOTP = async () => {
        try {
            const data = new FormData();
            data.append('email', formData.email);
            data.append('otp', parseInt(formData.otp, 10));

            const response = await fetch(`http://localhost:8080/api/v1/auth/verifyOTP`, {
                method: 'POST',
                body: data,
                headers: {
                  'Authorization': `Bearer ${token}`,
                },
              });
    
            
            setOtpVerified(true);
        } catch (error) {
            alert('Incorrect OTP entered');
        }
    };
    
    
      useEffect(() => {
        let interval;
        if (resendCooldown > 0) {
          interval = setInterval(() => {
            setResendCooldown((prev) => Math.max(prev - 1, 0));
          }, 600);
        }
        return () => clearInterval(interval);
      }, [resendCooldown]);

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        let newValue = value;
      setFormData({ ...formData, [e.target.name]: e.target.value });
      if (name === 'confirmPassword') {
        setPasswordMatch(formData.password === value);
      }

      if (name === 'telephoneNumber') {
        // Remove any non-digit characters
        newValue = newValue.replace(/\D/g, '');
        // Ensure the number starts with 0 and has 10 digits
        if (newValue.length > 0) {
          newValue = '0' + newValue.substring(0, 9);
        }
      }
    
    };
    const handleFileChange = (e) => {
        const allowedTypes = ['image/jpeg', 'image/png'];
      
        if (e.target.files && e.target.files.length > 0) {
            const file = e.target.files[0];
        
            // Validate file type
            if (allowedTypes.includes(file.type)) {
                setFormData({ ...formData, [e.target.name]: file });
        
                // Read the image and set the preview
                const reader = new FileReader();
        
                reader.onload = (event) => {
                    const imagePreview = event.target.result;
                    setFormData((prevData) => ({ ...prevData, [`${e.target.name}Preview`]: imagePreview }));
                };
        
                reader.readAsDataURL(file);
            } else {
                alert('Invalid file type. Please upload a JPEG or PNG image.');
            }
        } else {
            // Clear the file and the preview if the user deselects the file
            setFormData((prevData) => ({ ...prevData, [e.target.name]: null, [`${e.target.name}Preview`]: null }));
        }
    };
    
  
    const handleSubmit = async (e) => {
      e.preventDefault();
        
    if(
        !validateEmail() ||
        !validateFullName() ||
        !validateTelephone() ||
        !validateDob() ||
        !validatePassword() 
 ){
                alert("Not achive required criteria");
                return;
    }else{

        if(formData.photo != null){
        
    if(formData.email !== ''){         
            const data = new FormData();
            data.append('request', JSON.stringify(formData));
            data.append('photo', formData.photo);

  
      try {
        const response = await fetch(`http://localhost:8080/api/v1/admin/register`, {
          method: 'POST',
          body: data,
          headers: {
            'Authorization': `Bearer ${token}`,
          },
        });
  
        if (response.ok) {
          alert('User saved successfully')
          console.log('User saved successfully');
          navigate('/adminPage');
          window.location.reload();
        } else if(response.status == '400') {
          const error = await response.text();

          alert(`Error saving user: Email already exist.`)
        }else{
            const error = await response.text();
            setErrorMessage(`Error saving user: ${error}`);
            alert(errorMessage)
            navigate('/adminPage');
            window.location.reload();
        }
      } catch (error) {
        console.error('Error:', error);
        setErrorMessage('Error saving user.');
        alert(errorMessage)
        navigate('/adminPage');
        window.location.reload();
      } 
    }else{
        alert("Please add email.")
    }
    }else{
        alert("User photo is empty. So, please, add a user's photo.")
    }
        }
      
      
    };
  
    const validateTelephone = () => {
      const telephoneRegex = /^0\d{9}$/;
      if (!telephoneRegex.test(formData.telephone)) {
        setTelephoneError('Telephone should be 10 digits and start with 0.');
        return false;
      } else {
        setTelephoneError('');
        return true;
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
        <center>Add a Admin.</center>
      </div>
      <form onSubmit={handleSubmit} className='container my-4 fs-5 text-left'>

        
        <div className='row my-4 '>
          
          <div className='col-lg-5 col-md-12 mx-4 '>
            <label className='mb-1'>Full Name: </label>
            <input  type="text" name="fullname" onChange={handleInputChange} className='form-control' required value={formData.fullname} onBlur={validateFullName} />
          </div>
          <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Initial with Name: "</label>
            <input type="text" name="intName" onChange={handleInputChange} value={formData.intName} className='form-control' required />
          </div>
        </div>
        <div className='row my-4'>
        <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>E-mail:</label>
            <input type="email" name="email" onChange={handleInputChange} className='form-control' value={formData.email} required disabled={otpVerified}/>
            <div className ='fs-6'  style={{ color: 'red' }}>{emailError}</div>
        </div>
          <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Residence: </label>
            <input type="text" name="residence" onChange={handleInputChange} value={formData.residence} className='form-control' required />
          </div>
        </div>       
        <div className='row my-4'>
          <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Date of Birth:</label>
            <input type="text" name="dob" onChange={handleInputChange} onBlur={validateDob} className='form-control' value={formData.dob} required/>
            <div className ='fs-6'  style={{ color: 'red' }}>{dobError}</div>    
          </div>
          <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Address: </label>
            <input  type="text" name="address" onChange={handleInputChange} className='form-control' value={formData.address} required />         
          </div>
        </div>
  
        <div className='row my-4'>
              <div className='col-lg-5 col-md-12 mx-4'>
                <label className='mb-1'>Gender:</label>
                <select value={formData.gender} name="gender" onChange={handleInputChange} className='form-control' required>
                  <option value="" disabled>Select Gender</option>
                  <option value="male">Male</option>
                  <option value="female">Female</option>
                </select>
              </div>

          <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Telephone Number: </label>
            <input name="telephone" onChange={handleInputChange} className='form-control' required value={formData.telephoneNumber}  onBlur={validateTelephone} placeholder="07xxxxxxxx" ></input>
            <div className ='fs-6' style={{ color: 'red' }}>{telephoneError}</div>
          </div>
        </div>
                 {/* Password */}
      <div className='row my-4'>
        <div className='col-lg-5 col-md-12 mx-4'>
          <label className='mb-1'>Password:</label>
          <div className='row'>
            <div className='col-lg-10'>
                <input type={showPassword ? 'text' : 'password'} onBlur={validatePassword} value={formData.password} name="password" onChange={handleInputChange} className='form-control' required/>
            </div>
            <div className='col-lg-2'>
                    <button
                    className='btn btn-outline-secondary'
                    type='button'
                    onClick={togglePasswordVisibility}
                >
                    {showPassword ? 'Hide' : 'Show'} 
                </button>
            </div>
            
          </div>

          
          <div className ='fs-6'  style={{ color: 'red' }}>{passwordError}</div>
        </div>

        <div className='col-lg-5 col-md-12 mx-4'>
          <label className='mb-1'>Confirm Password:</label>
          <div className='row'>
            <div className='col-lg-10'>
            <input type={showPassword1 ? 'text' : 'password'} value={formData.confirmPassword} name="confirmPassword" onBlur={validateConfirmPassword} onChange={handleInputChange} className='form-control' required/>
                            {/* Display error message if passwords don't match */}
            {!passwordMatch && (
                <div className="row my-2 ">
                <div className="col-lg-10 col-md-12 mx-4">
                    <span className="text-danger fs-6">Passwords do not match.</span>
                </div>
                </div>
            )}
            </div>
            <div className='col-lg-2'>
                    <button
                    className='btn btn-outline-secondary'
                    type='button'
                    onClick={togglePasswordVisibility1}
                >
                    {showPassword1 ? 'Hide' : 'Show'} {/* Toggle button text */}
                </button>
            </div>
            
          </div>
        </div>

      </div>

        <div className='row my-4 '>
            <div className='col-lg-12 col-md-12 my-4'>
                <center><label className='my-4'>Conductor Photo (JPEG/PNG only):</label></center>
                <center><input type="file" name="photo" accept=".jpeg, .jpg, .png" onChange={handleFileChange} required/></center>
                <center>{formData.photo && (
                    <img src={formData.photoPreview} alt="Preview" style={{ width: '200px', maxHeight: '200px' }}  className='mt-3'required />
                )}</center>
            </div>
        </div>

        <div className='row'>
        {true && (
                    <button type="button" class="btn btn-warning m-4" onClick={handleSubmit}>
                            Submit
                    </button>
                )} 
        </div>
                    <br/>
        <div className='container'>
            <div className='row'>
            <div className='col-6 m-4'>
                      {otpSent && !otpVerified && (
                        <>
                        <label className='px-1'>
                            Enter OTP:  <input type="text" name="otp" />
                        </label>
                        <button type="button" onClick={handleVerifyOTP} class="btn btn-warning mx-2">
                            Verify OTP
                        </button>
                        </>
                    )}
            </div>
                <div className='col-lg-5 m-4'>
                {!otpVerified && (
                    <>
                        <button
                        type="button"
                        onClick={otpSent ? handleResendOTP : handleSendOTP}
                        disabled={resendCooldown > 0}
                        className="btn btn-warning mx-2"
                        >
                        {otpSent ? 'Resend OTP' : 'Send OTP'}
                        </button>
                        {resendCooldown > 0 && <p>Resend cooldown: {resendCooldown} seconds</p>}
                    </>
                    )}
                </div>
  
            </div> 
        </div>  
        <div className='container'>
            <div className='row col-10'>
     
            </div>
   
        </div>
      </form>
      </>
    );
}

export default AddAdminUser