
component {

  function init(javaloader) {
    cl = javaloader;
    java = {
      System : cl.create("java.lang.System")
      , File : cl.create("java.io.File")
      , URL : cl.create("java.net.URL")
      , Arrays : cl.create("java.util.Arrays")
      , ByteArrayInputStream : cl.create("java.io.ByteArrayInputStream")
      , BufferedReader : cl.create("java.io.BufferedReader")
      , InputStreamReader : cl.create("java.io.InputStreamReader")
      , FBVersions : cl.create("com.restfb.Version")
      , DefaultFacebookClient : cl.create("com.restfb.DefaultFacebookClient")
      , Parameter : cl.create("com.restfb.Parameter")
      , ScopeBuilder : cl.create("com.restfb.scope.ScopeBuilder")
      , UserDataPermissions : cl.create("com.restfb.scope.UserDataPermissions")
//      , WebClient : cl.create("com.gargoylesoftware.htmlunit.WebClient")
    };
    return this;
  }
  
  function type(type){
    return cl.create("com.restfb.types." & type).class;
  }

  function getClient(accessToken) {
    var version = java.FBVersions.VERSION_2_3;
    var facebookClient = java.DefaultFacebookClient.init(accessToken, version);
    return facebookClient;
  }

  function getAppClient(accessToken, appSecret) {
    var version = java.FBVersions.VERSION_2_3;
    var facebookClient = java.DefaultFacebookClient.init(accessToken, appSecret, version);
    return facebookClient;
  }

  function getApplicationAccessToken(appID,appSecret) {
    var accessToken = java.DefaultFacebookClient.init().obtainAppAccessToken(appID, appSecret);
    return accessToken;
  }

  function obtainAppSecretProof(appID,appSecret) {
    var proof = java.DefaultFacebookClient.init().obtainAppSecretProof(appID, appSecret);
    return proof;
  }

  function getLoginDialogUrl(appId, redirectUrl, array permissions=["USER_ABOUT_ME"]) {
    var scopeBuilder = java.ScopeBuilder.init();
    for(var permission in permissions) {
      scopeBuilder.addPermission(java.UserDataPermissions[permission]);
    }
    var version = java.FBVersions.VERSION_2_3;
    var facebookClient = java.DefaultFacebookClient.init(version);
    return facebookClient.getLoginDialogUrl(appId, redirectUrl, scopeBuilder);
  }

  function getApplication(facebookClient, appID, parameters="") {
    var params = [];
    for (var param in parameters) {
      arrayAppend(params,java.Parameter.with(param,parameters[param]));
    }
    var user = facebookClient.fetchObject(appID, type("Application"),params);
    return user;
  }

  function getUserInfo(facebookClient,parameters="") {
    var params = [];
    for (var param in parameters) {
      arrayAppend(params,java.Parameter.with(param,parameters[param]));
    }
    request.debug(params);
    var user = facebookClient.fetchObject("me", type("User"),params);
    return user;
  }



  /**
   * Access point for this component.  Used for thread context loader wrapping.
   **/
  function callMethod(methodName, required methodArguments) {
    var jThread = cl.create("java.lang.Thread");
    var cTL = jThread.currentThread().getContextClassLoader();
    jThread.currentThread().setContextClassLoader(cl.getLoader().getURLClassLoader());
    try{
      var theMethod = this[methodName];
      return theMethod(argumentCollection=methodArguments);
    } catch (any e) {
      jThread.currentThread().setContextClassLoader(cTL);
      throw(e);
    }
    jThread.currentThread().setContextClassLoader(cTL);
  }

}