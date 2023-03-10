/*JOBS 테이블에서 JOB_ID로 직원들의 JOB_TITLE, EMAIL, 성, 이름 검색*/
SELECT * FROM JOBS;

SELECT  J.JOB_ID, J.JOB_TITLE, E.EMAIL, E.LAST_NAME 성, E.FIRST_NAME 이름
FROM JOBS J JOIN EMPLOYEES E
ON J.JOB_ID = E.JOB_ID;

/*EMP 테이블의 SAL을 SALGRADE 테이블의 등급으로 나누기*/
SELECT * FROM EMP;
SELECT * FROM JOBS;

/*EMP 테이블의 SAL과 SALGRADE 테이블을 조인으로 연결해 E.SAL과 S.LO 및 S.HI SAL을 연결하여 테이블 출력*/
SELECT * 
FROM SALGRADE S JOIN EMP E 
ON E.SAL BETWEEN S.LOSAL AND S.HISAL;


/*EMPLOYEES 테이블에서 HIREDATE가 2003~2005년까지인 사원의 정보와 부서명 검색*/
SELECT * FROM EMPLOYEES;

SELECT HIRE_DATE  FROM EMPLOYEES
WHERE HIRE_DATE BETWEEN TO_DATE(2003, 'YYYY') AND TO_DATE(2005, 'YYYY');

SELECT D.DEPARTMENT_NAME, E.*
FROM DEPARTMENTS D JOIN EMPLOYEES E 
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID AND 
 HIRE_DATE BETWEEN TO_DATE(2003, 'YYYY') AND TO_DATE(2005, 'YYYY');



SELECT D.DEPARTMENT_NAME, E.*  
FROM EMPLOYEES E JOIN DEPARTMENTS D ON
E.DEPARTMENT_ID = D.DEPARTMENT_ID AND
E.HIRE_DATE BETWEEN TO_DATE('2003', 'YYYY') AND TO_DATE('2005', 'YYYY');

SELECT SYS_CONTEXT('USERENV', 'NLS_DATE_FORMAT') FROM DUAL;
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';



/*JOB_TITLE 중 'Manager'라는 문자열이 포함된 직업들의 평균 연봉을 JOB_TITLE별로 검색*/
SELECT * FROM EMPLOYEES;
SELECT * FROM JOBS;

SELECT J.JOB_TITLE, E.SALARY 
FROM JOBS J JOIN EMPLOYEES E
ON J.JOB_ID = E.JOB_ID AND JOB_TITLE LIKE '%Manager%';

/*EMP 테이블에서 ENAME에 L이 있는 사원들의 DNAME과 LOC 검색*/
SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT E.ENAME, D.LOC 
FROM DEPT D JOIN EMP E 
ON D.DEPTNO = E.DEPTNO AND E.ENAME LIKE '%L%';

/*축구 선수들 중에서 각 팀별로 키가 가장 큰 선수들 전체 정보 검색*/
SELECT * FROM PLAYER;
SELECT * FROM TEAM;

SELECT P1.*
FROM PLAYER P1 JOIN 
(
	SELECT TEAM_ID, MAX(HEIGHT) HEIGHT FROM PLAYER GROUP BY TEAM_ID
) P2
ON P1.TEAM_ID = P2.TEAM_ID AND P1.HEIGHT = P2.HEIGHT
ORDER BY P1.TEAM_ID;


SELECT P1.*
FROM PLAYER P1 JOIN
(
   SELECT TEAM_ID, MAX(HEIGHT) HEIGHT FROM PLAYER
   GROUP BY TEAM_ID
) P2
ON P1.TEAM_ID = P2.TEAM_ID AND P1.HEIGHT = P2.HEIGHT
ORDER BY P1.TEAM_ID;


SELECT TEAM_ID, MAX(HEIGHT) FROM PLAYER GROUP BY TEAM_ID ;
;
/*(A, B) IN (C, D) : A = C AND B = D*/

/*EMP 테이블에서 사원의 이름과 매니저 이름을 검사 */

SELECT * FROM EMP;
SELECT ENAME  FROM EMP;
SELECT EMPNO  FROM EMP;

SELECT E1.ENAME EMPLOYEE, MGR.ENAME MANAGER 
FROM EMP E1 JOIN EMP MGR
ON E1.MGR = MGR.EMPNO;

/*[브론즈]*/
/*PLAYER 테이블에서 키가 NULL인 선수들은 키를 170으로 변경하여 평균 구하기(NULL 포함)*/
SELECT NVL(HEIGHT, 170) FROM PLAYER;

/*[실버]*/
/*PLAYER 테이블에서 팀 별 최대 몸무게*/
SELECT TEAM_ID, MAX(WEIGHT) FROM PLAYER
GROUP BY TEAM_ID;

/*[골드]*/
/*AVG 함수를 쓰지 않고 PLAYER 테이블에서 선수들의 평균 키 구하기(NULL 포함)*/
SELECT SUM( NVL(HEIGHT, 0 )) /  COUNT( NVL(HEIGHT , 0)) FROM PLAYER;

/*[플래티넘]*/
/*DEPT 테이블의 LOC별 평균 급여를 반올림한 값과 각 LOC별 SAL 총 합을 조회, 반올림 : ROUND()*/
SELECT * FROM DEPT;
SELECT * FROM EMP;

SELECT D.LOC, ROUND(AVG(E.SAL), 2) "평균 급여", SUM(E.SAL) "총 합"
FROM DEPT D JOIN EMP E 
ON D.DEPTNO  = E.DEPTNO
GROUP BY D.LOC;

/*[다이아]*/
/*PLAYER 테이블에서 팀별 최대 몸무게인 선수 검색*/
SELECT TEAM_ID, MAX(WEIGHT) MAX_WEIGHT
FROM PLAYER
GROUP BY TEAM_ID;

SELECT P2.* FROM
(
	SELECT TEAM_ID, MAX(WEIGHT) MAX_WEIGHT FROM PLAYER 
	GROUP BY TEAM_ID
)P1 JOIN PLAYER P2 
ON P1.TEAM_ID = P2.TEAM_ID AND P1.MAX_WEIGHT = P2.WEIGHT
ORDER BY P2.TEAM_ID;


/*[마스터]*/
/*EMP 테이블에서 HIREDATE가 FORD의 입사년도와 같은 사원 전체 정보 조회*/
SELECT TO_CHAR(HIREDATE, 'YYYY')  FROM EMP
WHERE ENAME ='FORD';

SELECT * FROM EMP
WHERE TO_CHAR(HIREDATE, 'YYYY') = (SELECT TO_CHAR(HIREDATE, 'YYYY')  FROM EMP WHERE ENAME ='FORD');

/*외부 조인*/
/*JOIN 할 때 선행 또는 후행 중 하나의 테이블 정보를 모두 확인하고 싶을 때 사용한다.*/
SELECT NVL(TEAM_NAME, '공용'), S.*
FROM TEAM T RIGHT OUTER JOIN STADIUM S
ON T.TEAM_ID = S.HOMETEAM_ID;

/*DEPARTMENTS 테이블에서 매니저 이름 검색, 매S니저가 없더라도 부서명 모두 검색*/
SELECT D.DEPARTMENT_NAME, NVL(E.LAST_NAME, 'NO') || ' ' || NVL(E.FIRST_NAME, 'NAME')
FROM DEPARTMENTS D LEFT OUTER JOIN EMPLOYEES E
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID AND D.MANAGER_ID = E.EMPLOYEE_ID;

SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;

/*EMPLOYEES 테이블에서 사원의 매니저 이름, 사원의 이름 조회, 매니저가 없는 사원은 본인이 매니저임을 표시*/
SELECT E1.FIRST_NAME "사원 이름", NVL(E2.FIRST_NAME, E1.FIRST_NAME) "매니저 이름"
FROM EMPLOYEES E1 LEFT OUTER JOIN EMPLOYEES E2
ON E1.MANAGER_ID = E2.EMPLOYEE_ID;

/*EMPLOYEES에서 각 사원별로 관리부서(매니저)와 소속부서(사원) 조회*/
SELECT E1.JOB_ID 관리부서, E2.JOB_ID 소속부서, E2.FIRST_NAME 이름
FROM
(
   SELECT JOB_ID, MANAGER_ID FROM EMPLOYEES
   GROUP BY JOB_ID, MANAGER_ID
) E1 
FULL OUTER JOIN EMPLOYEES E2
ON E1.MANAGER_ID = E2.EMPLOYEE_ID
ORDER BY 소속부서 DESC;


