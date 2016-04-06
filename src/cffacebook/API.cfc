component {
  function init(reload=false)  {
    dm = new dependency.Manager();
    var depdir = getDirectoryFromPath(getMetadata(this).path) & "/dependency/restfb/";
    dm.materialize("com.restfb:restfb:1.19.0",depdir,false);
//    dm.materialize("net.sourceforge.htmlunit:htmlunit:2.17",depdir,false);  // for unit tests
    javaloader = new cffacebook.dependency.javatools.LibraryLoader(id="facebook-classloader", pathlist=depdir, force=reload);
    facebook = new cffacebook.facebook(javaloader);
    return this;
  }

  function onMissingMethod( methodName, methodArguments ) {
    return facebook.callMethod(argumentCollection=arguments);
  }

}