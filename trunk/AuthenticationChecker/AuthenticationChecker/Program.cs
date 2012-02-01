using System;

namespace AuthenticationChecker
{
	class Program
	{
		static LDAPAuthenticationService.ServicesSoapClient soapClient = new AuthenticationChecker.LDAPAuthenticationService.ServicesSoapClient();
		static object o;
		static string user;
		static string password;
		static string role;

		static int testNumber;

		static void Main(string[] args)
		{
			testNumber = 1;
			user = args.Length > 0 ? args[0] : "";
			password = args.Length > 1 ? args[1] : "";
			role = args.Length > 2 ? @"/l=Europe/o=Eionet/ou=Roles/cn=" + args[2] : "";

			if (testNumber == 1)
			{
				try
				{
					o = soapClient.LDAPAuthenticationCheck("uid=" + user + ",ou=Users,o=Eionet,l=Europe", password, "LDAP://ldap.eionet.europa.eu:389", role);
					soapClient.Close();
				}
				catch (Exception)
				{
					soapClient.Abort();
				}

				if (o.ToString().StartsWith("1"))
				{
					Console.ForegroundColor = ConsoleColor.Green;
					Console.WriteLine(Environment.NewLine + user + " authenticated." + Environment.NewLine);
					Console.ForegroundColor = ConsoleColor.Gray;
				}
				else
				{
					Console.ForegroundColor = ConsoleColor.Red;
					Console.WriteLine(Environment.NewLine + user + " not authenticated. " + Environment.NewLine + Environment.NewLine + o.ToString().Substring(4) + Environment.NewLine);
					Console.ForegroundColor = ConsoleColor.Gray;
				}
			}
			else if (testNumber == 2)
			{
				user = user.Equals("") ? "" : @"/l=Europe/o=Eionet/ou=Roles/cn=" + user;
				try
				{
					// Replace USERNAME and PASSWORD with your own data - then use the console application to test possible roles on this user
					o = soapClient.LDAPAuthenticationCheck("uid=XXX_USERNAME_XXX,ou=Users,o=Eionet,l=Europe", "XXX_PASSWORD_XXX", "LDAP://ldap.eionet.europa.eu:389", user);
					soapClient.Close();
				}
				catch (Exception)
				{
					soapClient.Abort();
				}
				if (o.ToString().Equals("0 - Rejected: There is no such object on the server"))
				{
					Console.ForegroundColor = ConsoleColor.Red;
					Console.WriteLine(Environment.NewLine + "Role doesn't exist" + Environment.NewLine);
					Console.ForegroundColor = ConsoleColor.Gray;
				}
				else if (o.ToString().Equals("0 - Rejected: User found but role not found"))
				{
					Console.ForegroundColor = ConsoleColor.Yellow;
					Console.WriteLine(Environment.NewLine + "Role not found on user" + Environment.NewLine);
					Console.ForegroundColor = ConsoleColor.Gray;
				}
				else if (o.ToString().StartsWith("1"))
				{
					Console.ForegroundColor = ConsoleColor.Green;
					Console.WriteLine(Environment.NewLine + "Authenticated!" + Environment.NewLine);
					Console.ForegroundColor = ConsoleColor.Gray;
				}
			}
		}
	}
}