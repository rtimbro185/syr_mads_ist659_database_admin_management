

SELECT UserName, vc_UserLogin.*
FROM vc_User
JOIN vc_UserLogin on vc_UserLogin.vc_UserID = vc_User.vc_UserID
