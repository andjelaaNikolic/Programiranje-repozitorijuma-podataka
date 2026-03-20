using Microsoft.Data.SqlClient;
using System;
using System.Data;

namespace DBBroker
{
    public class DBConnection
    {
        SqlConnection connection = new SqlConnection("Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=treninzi;Integrated Security=True;Connect Timeout=30;Encrypt=False;Trust Server Certificate=False;Application Intent=ReadWrite;Multi Subnet Failover=False");
        SqlTransaction transaction;

        public void Rollback()
        {
            if (transaction == null)
                return;

            try
            {
               
                if (transaction.Connection != null)
                    transaction.Rollback();
            }
            catch (InvalidOperationException)
            {
               
            }
            finally
            {
                transaction = null;
            }
        }

        public void Commit()
        {
            if (transaction == null)
                throw new InvalidOperationException("No active transaction to commit.");

            try
            {
                if (transaction.Connection != null)
                    transaction.Commit();
            }
            finally
            {
                transaction = null;
            }
        }

        public void BeginTransaction()
        {
            if (connection.State != ConnectionState.Open)
                connection.Open();

          
           if (transaction != null && transaction.Connection != null)
                throw new InvalidOperationException("An active transaction already exists.");

            transaction = connection.BeginTransaction();
        }

        public void CloseConnection()
        {

            if (connection.State == ConnectionState.Closed)
                return;

            if (transaction != null && transaction.Connection != null)
                return;

            connection.Close();
        }

        public void OpenConnection()
        {
            if (connection.State != ConnectionState.Open)
                connection.Open();
        }

        public SqlCommand CreateCommand()
        {
            var cmd = new SqlCommand("", connection);
            if (transaction != null && transaction.Connection != null)
                cmd.Transaction = transaction;
            return cmd;
        }
    }
}
