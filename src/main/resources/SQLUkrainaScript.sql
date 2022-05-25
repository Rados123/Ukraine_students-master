create database Ukraina_Uczniowie
use Ukraina_Uczniowie

--wykorzystaæ sql import manager, szukaj import w pasku startu, bierzesz plik excela bo formatowanie, zmieni³em 3 ostatnie kolumny na int, ale to nie ma za du¿ego znaczenia

select * from Uczniowie_uchodzcy_z_Ukrainy_be$
--zmiana nazwy
exec sp_rename 'Uczniowie_uchodzcy_z_Ukrainy_be$', 'Ukraina_Uczniowie'
select * from Ukraina_Uczniowie
--tworzenie kopii
select * into Ukraina_Uczniowie_kopia from Ukraina_Uczniowie
select * into Ukraina_Uczniowie_kopia2 from Ukraina_Uczniowie
select * into Ukraina_Uczniowie_odczyt from Ukraina_Uczniowie
go
--tworzenie usera do odczytu, nie potrzebne uprawnienia do selecta 
create login UserOdczyt with password='haslo123'
go
create user UserOdczyt for login UserOdczyt
go

grant select on Ukraina_Uczniowie to UserOdczyt
deny select on Ukraina_Uczniowie to UserOdczyt


--dodanie identity
alter table Ukraina_Uczniowie
add ID int Identity(1,1) not null
go
alter table Ukraina_Uczniowie
add constraint pk_uczniowie_ID primary key(ID)

--zmiana nazw kolumn na cos bardziej znosnego
exec sp_rename 'Ukraina_Uczniowie.Województwo', 'Wojewodztwo'
exec sp_rename 'Ukraina_Uczniowie.Publicznoœæ', 'Publicznosc'
exec sp_rename 'Ukraina_Uczniowie.[Typ podmiotu]', 'TypPodmiotu'
exec sp_rename 'Ukraina_Uczniowie.[Liczba szkó³]', 'LiczbaSzkol'
exec sp_rename 'Ukraina_Uczniowie.[Liczba uczniów uchodŸców z Ukrainy]', 'Ukraincy'
exec sp_rename 'Ukraina_Uczniowie.[w tym z dodatkow¹ bezp³atn¹ nauk¹ jêzyka polskiego]', 'NaukaPolskiego'


select * from Ukraina_Uczniowie where idTypPodmiotu=3 and idTerytPowiat=2212
select distinct idPublicznosc from Ukraina_Uczniowie
select * from Ukraina_Uczniowie where idPublicznosc=5
select distinct idTerytPowiat, Powiat from Ukraina_Uczniowie
--PROCEDURY TESTOWE
go
create procedure pokaz_powiat
@idTerytPowiat float
as
begin
	select * from Ukraina_Uczniowie where  idTerytPowiat=@idTerytPowiat
end

go
exec pokaz_powiat 2212

go

create procedure pokaz_powiat_0
@idTerytPowiat float, @idPublicznosc float
as
begin
	if @idTerytPowiat=0 and @idPublicznosc=0
	begin
		select * from Ukraina_Uczniowie
	end
	else if @idTerytPowiat=0
	begin
		select * from Ukraina_Uczniowie where  idPublicznosc=@idPublicznosc
	end
	else if @idPublicznosc=0
	begin
		select * from Ukraina_Uczniowie where  idTerytPowiat=@idTerytPowiat
	end
	else
	begin
		select * from Ukraina_Uczniowie where  idTerytPowiat=@idTerytPowiat and idPublicznosc=@idPublicznosc
	end
end

go
drop procedure pokaz_powiat_0
exec pokaz_powiat_0 201,1

go
--PROCEDURA SELECT WSZYSTKO z parametrami 
create procedure pokaz_szkoly_all
@idTerytWojewodztwo float, @idTerytPowiat float, @idPublicznosc float,  @idTypPodmiotu float
as
begin
	if @idTerytWojewodztwo=0 and @idTerytPowiat=0 and @idPublicznosc=0 and @idTypPodmiotu=0
		begin
			select * from Ukraina_Uczniowie
		end
	else if @idTerytWojewodztwo=0 and @idTerytPowiat=0 and @idPublicznosc=0
		begin
			select * from Ukraina_Uczniowie where  idTypPodmiotu=@idTypPodmiotu
		end
	else if @idTerytWojewodztwo=0 and @idTerytPowiat=0 and @idTypPodmiotu=0
		begin
			select * from Ukraina_Uczniowie where  idPublicznosc=@idPublicznosc
		end
	else if @idTerytWojewodztwo=0 and @idTypPodmiotu=0 and @idPublicznosc=0
		begin
			select * from Ukraina_Uczniowie where  idTerytPowiat=@idTerytPowiat
		end
	else if  @idTerytPowiat=0 and @idPublicznosc=0 and @idTypPodmiotu=0
		begin
			select * from Ukraina_Uczniowie where  idTerytWojewodztwo=@idTerytWojewodztwo
		end
	else if @idTerytWojewodztwo=0 and @idTerytPowiat=0
		begin
			select * from Ukraina_Uczniowie where  idTypPodmiotu=@idTypPodmiotu and idPublicznosc=@idPublicznosc
		end		
	else if @idTerytWojewodztwo=0 and @idPublicznosc=0
		begin
			select * from Ukraina_Uczniowie where  idTypPodmiotu=@idTypPodmiotu and idTerytPowiat=@idTerytPowiat
		end
	else if @idTerytWojewodztwo=0 and @idTypPodmiotu=0
		begin
			select * from Ukraina_Uczniowie where  idTerytPowiat=@idTerytPowiat and idPublicznosc=@idPublicznosc
		end
	else if @idTerytPowiat=0 and @idPublicznosc=0
		begin
			select * from Ukraina_Uczniowie where  idTypPodmiotu=@idTypPodmiotu and idTerytWojewodztwo=@idTerytWojewodztwo
		end
	else if @idTerytPowiat=0 and @idTypPodmiotu=0
		begin
			select * from Ukraina_Uczniowie where  idPublicznosc=@idPublicznosc and idTerytWojewodztwo=@idTerytWojewodztwo
		end
	else if @idPublicznosc=0 and @idTypPodmiotu=0
		begin
			select * from Ukraina_Uczniowie where  idTerytPowiat=@idTerytPowiat and idTerytWojewodztwo=@idTerytWojewodztwo
		end
	else if @idTerytWojewodztwo=0
		begin
			select * from Ukraina_Uczniowie where  idTypPodmiotu=@idTypPodmiotu and idPublicznosc=@idPublicznosc and idTerytPowiat=@idTerytPowiat
		end
	else if @idTerytPowiat=0 
		begin
			select * from Ukraina_Uczniowie where idPublicznosc=@idPublicznosc and idTypPodmiotu=@idTypPodmiotu and idTerytWojewodztwo=@idTerytWojewodztwo
		end			
	else if @idPublicznosc=0 
		begin
			select * from Ukraina_Uczniowie where idTerytPowiat=@idTerytPowiat and idTypPodmiotu=@idTypPodmiotu and idTerytWojewodztwo=@idTerytWojewodztwo
		end	
	else if @idTypPodmiotu=0 
		begin
			select * from Ukraina_Uczniowie where idPublicznosc=@idPublicznosc and idTerytPowiat=@idTerytPowiat and idTerytWojewodztwo=@idTerytWojewodztwo
		end
	else
		begin
			select * from Ukraina_Uczniowie where idTerytWojewodztwo=@idTerytWojewodztwo and idTerytPowiat=@idTerytPowiat and idPublicznosc=@idPublicznosc and idTypPodmiotu=@idTypPodmiotu
		end
end
grant exec on pokaz_szkoly_all to UserOdczyt
deny exec on pokaz_szkoly_all to UserOdczyt
exec pokaz_szkoly_all 0,0,0,0
go
--PROCEDURA SELECT TYLKO Z DANYMI KTORE POWINNY BYC DOSTEPNE DLA USERA
create procedure pokaz_szkoly_all_NoID
@idTerytWojewodztwo float, @idTerytPowiat float, @idPublicznosc float,  @idTypPodmiotu float
as
begin
	if @idTerytWojewodztwo=0 and @idTerytPowiat=0 and @idPublicznosc=0 and @idTypPodmiotu=0
		begin
			select Wojewodztwo, Powiat, Publicznosc, TypPodmiotu, LiczbaSzkol, Ukraincy, NaukaPolskiego from Ukraina_Uczniowie
		end
	else if @idTerytWojewodztwo=0 and @idTerytPowiat=0 and @idPublicznosc=0
		begin
			select Wojewodztwo, Powiat, Publicznosc, TypPodmiotu, LiczbaSzkol, Ukraincy, NaukaPolskiego from Ukraina_Uczniowie where  idTypPodmiotu=@idTypPodmiotu
		end
	else if @idTerytWojewodztwo=0 and @idTerytPowiat=0 and @idTypPodmiotu=0
		begin
			select Wojewodztwo, Powiat, Publicznosc, TypPodmiotu, LiczbaSzkol, Ukraincy, NaukaPolskiego from Ukraina_Uczniowie where  idPublicznosc=@idPublicznosc
		end
	else if @idTerytWojewodztwo=0 and @idTypPodmiotu=0 and @idPublicznosc=0
		begin
			select Wojewodztwo, Powiat, Publicznosc, TypPodmiotu, LiczbaSzkol, Ukraincy, NaukaPolskiego from Ukraina_Uczniowie where  idTerytPowiat=@idTerytPowiat
		end
	else if  @idTerytPowiat=0 and @idPublicznosc=0 and @idTypPodmiotu=0
		begin
			select Wojewodztwo, Powiat, Publicznosc, TypPodmiotu, LiczbaSzkol, Ukraincy, NaukaPolskiego from Ukraina_Uczniowie where  idTerytWojewodztwo=@idTerytWojewodztwo
		end
	else if @idTerytWojewodztwo=0 and @idTerytPowiat=0
		begin
			select Wojewodztwo, Powiat, Publicznosc, TypPodmiotu, LiczbaSzkol, Ukraincy, NaukaPolskiego from Ukraina_Uczniowie where  idTypPodmiotu=@idTypPodmiotu and idPublicznosc=@idPublicznosc
		end		
	else if @idTerytWojewodztwo=0 and @idPublicznosc=0
		begin
			select Wojewodztwo, Powiat, Publicznosc, TypPodmiotu, LiczbaSzkol, Ukraincy, NaukaPolskiego from Ukraina_Uczniowie where  idTypPodmiotu=@idTypPodmiotu and idTerytPowiat=@idTerytPowiat
		end
	else if @idTerytWojewodztwo=0 and @idTypPodmiotu=0
		begin
			select Wojewodztwo, Powiat, Publicznosc, TypPodmiotu, LiczbaSzkol, Ukraincy, NaukaPolskiego from Ukraina_Uczniowie where  idTerytPowiat=@idTerytPowiat and idPublicznosc=@idPublicznosc
		end
	else if @idTerytPowiat=0 and @idPublicznosc=0
		begin
			select Wojewodztwo, Powiat, Publicznosc, TypPodmiotu, LiczbaSzkol, Ukraincy, NaukaPolskiego from Ukraina_Uczniowie where  idTypPodmiotu=@idTypPodmiotu and idTerytWojewodztwo=@idTerytWojewodztwo
		end
	else if @idTerytPowiat=0 and @idTypPodmiotu=0
		begin
			select Wojewodztwo, Powiat, Publicznosc, TypPodmiotu, LiczbaSzkol, Ukraincy, NaukaPolskiego from Ukraina_Uczniowie where  idPublicznosc=@idPublicznosc and idTerytWojewodztwo=@idTerytWojewodztwo
		end
	else if @idPublicznosc=0 and @idTypPodmiotu=0
		begin
			select Wojewodztwo, Powiat, Publicznosc, TypPodmiotu, LiczbaSzkol, Ukraincy, NaukaPolskiego from Ukraina_Uczniowie where  idTerytPowiat=@idTerytPowiat and idTerytWojewodztwo=@idTerytWojewodztwo
		end
	else if @idTerytWojewodztwo=0
		begin
			select Wojewodztwo, Powiat, Publicznosc, TypPodmiotu, LiczbaSzkol, Ukraincy, NaukaPolskiego from Ukraina_Uczniowie where  idTypPodmiotu=@idTypPodmiotu and idPublicznosc=@idPublicznosc and idTerytPowiat=@idTerytPowiat
		end
	else if @idTerytPowiat=0 
		begin
			select Wojewodztwo, Powiat, Publicznosc, TypPodmiotu, LiczbaSzkol, Ukraincy, NaukaPolskiego from Ukraina_Uczniowie where idPublicznosc=@idPublicznosc and idTypPodmiotu=@idTypPodmiotu and idTerytWojewodztwo=@idTerytWojewodztwo
		end			
	else if @idPublicznosc=0 
		begin
			select Wojewodztwo, Powiat, Publicznosc, TypPodmiotu, LiczbaSzkol, Ukraincy, NaukaPolskiego from Ukraina_Uczniowie where idTerytPowiat=@idTerytPowiat and idTypPodmiotu=@idTypPodmiotu and idTerytWojewodztwo=@idTerytWojewodztwo
		end	
	else if @idTypPodmiotu=0 
		begin
			select Wojewodztwo, Powiat, Publicznosc, TypPodmiotu, LiczbaSzkol, Ukraincy, NaukaPolskiego from Ukraina_Uczniowie where idPublicznosc=@idPublicznosc and idTerytPowiat=@idTerytPowiat and idTerytWojewodztwo=@idTerytWojewodztwo
		end
	else
		begin
			select Wojewodztwo, Powiat, Publicznosc, TypPodmiotu, LiczbaSzkol, Ukraincy, NaukaPolskiego from Ukraina_Uczniowie where idTerytWojewodztwo=@idTerytWojewodztwo and idTerytPowiat=@idTerytPowiat and idPublicznosc=@idPublicznosc and idTypPodmiotu=@idTypPodmiotu
		end
end

grant exec on pokaz_szkoly_all_NoID to UserOdczyt


exec pokaz_szkoly_all 0,0,0,0
exec pokaz_szkoly_all_NoID 0,205,0,0