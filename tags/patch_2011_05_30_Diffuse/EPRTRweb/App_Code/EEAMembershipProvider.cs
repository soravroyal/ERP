using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using Microsoft.Practices.EnterpriseLibrary.Logging;

namespace TestLogin
{
    /// <summary>
    /// Review Site login, using EEA LDAP. Only method that is implimented is ValidateUser.
    /// </summary>
    public class EEAMembershipProvider: System.Web.Security.MembershipProvider
    {
        public override string ApplicationName
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        public override bool ChangePassword(string username, string oldPassword, string newPassword)
        {
            throw new NotImplementedException();
        }

        public override bool ChangePasswordQuestionAndAnswer(string username, string password, string newPasswordQuestion, string newPasswordAnswer)
        {
            throw new NotImplementedException();
        }

        public override System.Web.Security.MembershipUser CreateUser(string username, string password, string email, string passwordQuestion, string passwordAnswer, bool isApproved, object providerUserKey, out System.Web.Security.MembershipCreateStatus status)
        {
            throw new NotImplementedException();
        }

        public override bool DeleteUser(string username, bool deleteAllRelatedData)
        {
            throw new NotImplementedException();
        }

        public override bool EnablePasswordReset
        {
            get { throw new NotImplementedException(); }
        }

        public override bool EnablePasswordRetrieval
        {
            get { throw new NotImplementedException(); }
        }

        public override System.Web.Security.MembershipUserCollection FindUsersByEmail(string emailToMatch, int pageIndex, int pageSize, out int totalRecords)
        {
            throw new NotImplementedException();
        }

        public override System.Web.Security.MembershipUserCollection FindUsersByName(string usernameToMatch, int pageIndex, int pageSize, out int totalRecords)
        {
            throw new NotImplementedException();
        }

        public override System.Web.Security.MembershipUserCollection GetAllUsers(int pageIndex, int pageSize, out int totalRecords)
        {
            throw new NotImplementedException();
        }

        public override int GetNumberOfUsersOnline()
        {
            throw new NotImplementedException();
        }

        public override string GetPassword(string username, string answer)
        {
            throw new NotImplementedException();
        }

        public override System.Web.Security.MembershipUser GetUser(string username, bool userIsOnline)
        {
            throw new NotImplementedException();
        }

        public override System.Web.Security.MembershipUser GetUser(object providerUserKey, bool userIsOnline)
        {
            throw new NotImplementedException();
        }

        public override string GetUserNameByEmail(string email)
        {
            throw new NotImplementedException();
        }

        public override int MaxInvalidPasswordAttempts
        {
            get { throw new NotImplementedException(); }
        }

        public override int MinRequiredNonAlphanumericCharacters
        {
            get { throw new NotImplementedException(); }
        }

        public override int MinRequiredPasswordLength
        {
            get { throw new NotImplementedException(); }
        }

        public override int PasswordAttemptWindow
        {
            get { throw new NotImplementedException(); }
        }

        public override System.Web.Security.MembershipPasswordFormat PasswordFormat
        {
            get { throw new NotImplementedException(); }
        }

        public override string PasswordStrengthRegularExpression
        {
            get { throw new NotImplementedException(); }
        }

        public override bool RequiresQuestionAndAnswer
        {
            get { throw new NotImplementedException(); }
        }

        public override bool RequiresUniqueEmail
        {
            get { throw new NotImplementedException(); }
        }

        public override string ResetPassword(string username, string answer)
        {
            throw new NotImplementedException();
        }

        public override bool UnlockUser(string userName)
        {
            throw new NotImplementedException();
        }

        public override void UpdateUser(System.Web.Security.MembershipUser user)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateUser(string username, string password)
        {
           
            string path = ConfigurationManager.AppSettings["LDAPPath"];
            string myUsername = username;
            string uid = ConfigurationManager.AppSettings["LDAPUID"];
            string user = string.Format(uid, myUsername.ToLower());
            EEAServices myService = new EEAServices();
            string serviceUrl = ConfigurationManager.AppSettings["LDAPServiceAddress"];
            myService.Url = serviceUrl;

            var settings = System.Web.Configuration.WebConfigurationManager.AppSettings;

            var GetRoles = from string r in settings.Keys
                           where r.StartsWith("Role")
                           select settings[r];

            object mylogin = new object();            
            try
            {
                foreach (var r in GetRoles)
                {
                    mylogin = myService.LDAPAuthenticationCheck(user, password, path, r);

                    bool pass = (mylogin.ToString().Contains("1")); //"0 - Rejected: User found but role not found"
                    if (pass)
                    {
                        return true;
                    }

                }
                
            }
            catch (System.Net.WebException we)
            {
                LogEntry log = new LogEntry();

                log.EventId = 300;
                log.Message = "Failure in EEAMembershipProvider. User = " + username +". " + we.Message;
                log.Severity = System.Diagnostics.TraceEventType.Error;
                log.Categories.Add("Login");
                log.Priority = 5;
                Logger.Write(log);
            }
            catch (Exception ex)
            {
                LogEntry log = new LogEntry();

                log.EventId = 300;
                log.Message = "Failure in EEAMembershipProvider " + ex.Message;
                log.Severity = System.Diagnostics.TraceEventType.Warning;
                log.Categories.Add("Login");
                log.Priority = 5;
                Logger.Write(log);

                throw;
            }
            

            return false;
        }
    }
}
