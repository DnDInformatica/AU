using System;
using System.Data.SqlClient;
using System.Threading;
using System.Threading.Tasks;
using Dapper;

var cs = "Server=localhost,1434;Database=Accredia2025;User Id=sa;Password=Mollicone.73!;TrustServerCertificate=True;MultipleActiveResultSets=True;Encrypt=False;";
await using var cn = new SqlConnection(cs);
await cn.OpenAsync();

var sql = @"SELECT [Id], [UserName], [Email], [PasswordHash], [LockoutEnabled], [LockoutEnd]
FROM [Identity].[AspNetUsers]
WHERE ([NormalizedUserName] = @NormalizedUserNameOrEmail OR [NormalizedEmail] = @NormalizedUserNameOrEmail)
  AND ([LockoutEnd] IS NULL OR [LockoutEnd] < SYSDATETIMEOFFSET());";

var sw = System.Diagnostics.Stopwatch.StartNew();
var row = await cn.QuerySingleOrDefaultAsync(new CommandDefinition(sql, new { NormalizedUserNameOrEmail = "ADMIN" }, cancellationToken: CancellationToken.None));
sw.Stop();
Console.WriteLine($"DAPPER_MS={sw.ElapsedMilliseconds}");
Console.WriteLine(row is null ? "ROW=NULL" : "ROW=FOUND");
