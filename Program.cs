using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace CheckNpgsqlSetupStatus {
    class Program {
        static void Main(string[] args) {
            try {
                Thread.CurrentThread.CurrentUICulture = CultureInfo.InvariantCulture;

                Console.WriteLine("CheckNpgsqlSetupStatus {0} (.NET {1})", (IntPtr.Size == 4) ? "32bit" : "64bit", System.Runtime.InteropServices.RuntimeEnvironment.GetSystemVersion());
                Console.WriteLine("---");
                Console.WriteLine("Getting Npgsql");
                DbProviderFactory dbf = DbProviderFactories.GetFactory("Npgsql");
                Console.WriteLine("Done, it is {0}", (dbf != null) ? dbf.GetType().AssemblyQualifiedName : "null");
                Console.WriteLine("---");
                Console.WriteLine("Getting DbConnection");
                DbConnection db = dbf.CreateConnection();
                Console.WriteLine("Done, it is {0}", (db != null) ? db.GetType().AssemblyQualifiedName : "null");
            }
            catch (Exception err) {
                Console.Error.WriteLine(err);
            }
            Console.WriteLine();
            Console.WriteLine("Press enter to exit...");
            Console.ReadLine();
        }
    }
}