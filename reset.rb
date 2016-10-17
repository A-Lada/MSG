`heroku pg:reset DATABASE --app limitless-bastion-17201 --confirm limitless-bastion-17201`
`heroku run rake db:migrate --app limitless-bastion-17201`
`heroku restart --app limitless-bastion-17201`