# lightweight-koel-docker
Docker image running koël

## build

`$> docker build -t koel`

## run

```
docker run -ti -p 8000:8000 -v /path/to/your/library:/koel/media
	-e MEDIA_SYNC=false
    -e ADMIN_EMAIL=foo@bar.com
    -e ADMIN_PASSWORD=paswword koel
```

default email: admin@local.host
default password: password

