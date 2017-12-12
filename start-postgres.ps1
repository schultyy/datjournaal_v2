$cwd = Join-Path -Path (Get-Location) -ChildPath "postgres_data"
If(!(test-path $cwd))
{
  New-Item -ItemType directory -Path $cwd
}
docker run --name postgres-datjournaal -p 5432:5432 -e POSTGRES_PASSWORD=postgres -e POSTGRES_USER=postgres -v ${cwd}:"/var/lib/postgresql/data" -d postgres
