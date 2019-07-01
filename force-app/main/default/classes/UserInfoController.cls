public with sharing class UserInfoController {
    
    @AuraEnabled
    public static String getUserInfo(){ 
        String profileName = [select Name from profile where id = :Userinfo.getProfileId() limit 1].Name;
        
        UserInfoWrapper userInfoWrap = new UserInfoWrapper();
        userInfoWrap.profileName = profileName;
        userInfoWrap.userName = Userinfo.getFirstName()+' '+Userinfo.getLastName();
        return JSON.serialize(userInfoWrap); 
    }
    
}