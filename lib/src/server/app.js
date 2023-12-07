var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var mysql = require('mysql')
var connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '942652Xkf',
  database: 'pindemo'
})


var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;


app.get('/', (req, res) => {
  res.send('服务3000')
})
//注册
app.post('/register', (req, res) => {
  let userId = (new Date()).valueOf()
  let tel = req.body.tel
  let userName = req.body.userName
  let password = req.body.password
  if (util.strIsNotEmpty(tel) && util.strIsNotEmpty(userName) && util.strIsNotEmpty(password)) {
      ///查询是否存在用户
      connection.query(
          `SELECT * FROM pin_user where tel = \"${tel}\"`,
          function (err, rows, fields) {
              if (err) throw err
              if (rows.length != 0) {
                  res.send({
                      "code": 400,
                      "message": "用户存在"
                  })
              } else {
                  ///新增用户
                  connection.query(
                      `INSERT INTO pin_user (\`userId\`, \`userName\`, \`tel\`, \`password\`) VALUES (\"${userId}\", \"${userName}\", \"${tel}\", \"${password}\")`,
                      function (err, rows, fields) {
                          if (err) throw err
                          res.send({
                              "code": 0,
                              "message": "注册成功"
                          })
                      }
                  )
              }
          }
      )
  } else {
      res.send({
          "code": 500,
          "message": "输入不能为空"
      })
  }
})
//登录
app.post('/login', (req, res) => {
  let tel = req.body.tel
  let password = req.body.password
  if (util.strIsNotEmpty(tel) && util.strIsNotEmpty(password)) {
      ///查询是否存在用户
      connection.query(
          `SELECT * FROM pin_user where tel = \"${tel}\" && password = \"${password}\"`,
          function (err, rows, fields) {
              if (err) throw err
              if (rows.length != 0) {
                  res.send({
                      "code": 0,
                      "message": `欢迎${rows[0].userName}`,
                      "data": {
                          "userId": rows[0].userId, //用户id
                          "userName": rows[0].userName, //用户昵称
                          "avatar": rows[0].avatar, //头像
                      }
                  })
                  console.debug('login:')
                  console.debug(rows)
              } else {
                  res.send({
                      "code": 400,
                      "message": "用户不存在或者密码错误"
                  })
                  console.debug('loginFailed 400:')
                  console.debug(rows)
              }
          }
      )
  } else {
      res.send({
          "code": 500,
          "message": "输入不能为空"
      })
      console.debug('loginFailed 500:')
      console.debug(rows)
  }
})
//查询所有用户列表
app.get('/users', (req, res) => {
  connection.query(`SELECT userId, userName, avatar FROM pin_user`, function (err, rows, fields) {
      if (err) throw err
      res.send({
          "code": 0,
          "message": "获取用户列表成功",
          "data": rows
      })
      console.debug('getUsers:')
      console.debug(rows)
  })
})

app.listen(port, () => {
  connection.connect()
  console.log('服务3000启动...')
})
