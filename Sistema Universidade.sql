create database universidade;
use universidade;

-- tabela áreas
create table areas (
	id_area int auto_increment primary key,
    nome varchar (100) not null
);

-- tabela cursos
create table cursos(
	id_curso int auto_increment primary key,
    nome varchar (100) not null,
    id_area int,
    foreign key (id_area) references area(id_area)
);

-- tabela alunos
create table alunos(
	id_aluno int auto_increment primary key,
    nome varchar(50) not null,
    sobrenome varchar(50) not null,
    email varchar(100) unique not null
);

-- tabela matrículas
create table matriculas(
	id_matricula int auto_increment primary key,
    id_aluno int,
    id_curso int,
    foreign key (id_aluno) references alunos(id_aluno),
    foreign key (id_curso) references cursos(id_curso),
    unique (id_aluno, id_curso)
);

-- procedures 

-- inserir curso
DELIMITER //

create procedure sp_inserir_curso (
	in p_nome varchar (100),
    in p_id_area int
)
begin
	insert into cursos (nome, id_area) values (p_nome, p_id_area);
end //

DELIMITER ;

-- retorna curso

DELIMITER //

create function fn_obter_id_curso (
	p_nome varchar(100),
    p_area varchar(100)
) returns int
begin
	declare v_id int;
    select c.id_curso into v_id
    from cursos c
    join areas a on c.id_area = a.id_area
    where c.nome = p_nome and a.nome = p_area;
    
    return v_id;
end //

DELIMITER ;

-- matricular aluno

DELIMITER //

create procedure sp_matricular_aluno(
	in p_nome varchar(50),
    in p_sobrenome varchar(50),
    in p_id_curso int
)
begin
	declare v_id_aluno int;
    declare v_email varchar(100);
    
    -- gerar email
    set v_email = concat(p_nome, '.', p_sobrenome, '@dominio.com');
    
    -- inserir aluno
     if not exists (select * from alunos where email = v_email) then
        insert into alunos (nome, sobrenome, email) values (p_nome, p_sobrenome, v_email);
    end if;
    
    -- selecionar id aluno
    select id_aluno into v_id_aluno from alunos where email = v_email;
    
    -- matricular
      if not exists (select * from matriculas where id_aluno = v_id_aluno and id_curso = p_id_curso) THEN
        insert into matriculas (id_aluno, id_curso) values (v_id_aluno, p_id_curso);
    end if;
end //

DELIMITER ;

-- INSERÇÕES
	-- areas
insert into areas (nome) values ('Ciências Exatas'), ('Ciências Humanas'), ('Saúde'), ('Engenharia'), ('Tecnologia');
	
    -- cursos
DELIMITER //

create procedure sp_inserir_cursos_aleatorios()
begin
    declare i int default 1;
    declare area_id int;

    while i <= 25 DO
        set area_id = (FLOOR(1 + (RAND() * 5)));  -- Áreas variando de 1 a 5
        call sp_inserir_curso(CONCAT('Curso', i), area_id);
        set i = i + 1;
    end while;
end //

DELIMITER ;

-- executa inserção
call sp_inserir_cursos_aleatorios();

	-- alunos
DELIMITER //

create procedure sp_inserir_alunos_aleatorios()
begin
    declare i int default 1;
    declare nome varchar(50);
    declare sobrenome varchar(50);

    while i <= 200 do
        set nome = CONCAT('Nome', i);
        set sobrenome = CONCAT('Sobrenome', i);
        call sp_matricular_aluno(nome, sobrenome, (FLOOR(1 + (RAND() * 25)))); -- Cursos variando de 1 a 25
        set i = i + 1;
    end while;
end //

DELIMITER ;

-- executa inserção
call sp_inserir_alunos_aleatorios();


-- select das tables

select*from alunos;
select*from cursos;
select*from areas;
    


    

    
    





