class ProcessSignUp{

  var email;
  var username;
  var password;
  int errCode;
  var errMsg;

  ProcessSignUp({this.email, this.username, this.password});

  Object validateEmail(){
    Pattern pattern = r'^[A-Za-z0-9]+(?:[@_\.-][A-Za-z0-9]+)*$';
    RegExp regex = new RegExp(pattern);
    if(!regex.hasMatch(username)){

      return {errCode: errMsg};
    }
    else {
      //check if duplicate email exists in firebase
      return {errCode: errMsg};
    }
  }

  Object validateUsername(){
    Pattern pattern = r'^[a-z]+[0-9_]*[a-z0-9]*';
    RegExp regex = new RegExp(pattern);
    if(!regex.hasMatch(username)){
      return {errCode: errMsg};
    }
    else{
      //check if duplicate username exists in firebase
      return {errCode: errMsg};
    }
  }

  Object validatePassword(){
    Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$';
    RegExp regex = new RegExp(pattern);
    if(!regex.hasMatch(password)){
      return {errCode: errMsg};
    }
    else{
      // Return no error
      return {errCode: errMsg};
    }
  }
  // Call this method if none of the above methods return errors
  Object processSignupRequest(){

    // Sign Up user below

    return {errCode: errMsg};

  }
}