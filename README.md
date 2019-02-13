# ime_busco
A Docker image providing the BUSCO software

## Prerequisities

In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

## Usage

The docker image provides the [BUSCO](https://busco.ezlab.org/) tool. It will run the `run_BUSCO.py` command as entrypoint.
Therefore, running a container is as easy as:

```
docker run --rm greatfireball/ime_busco --version
```

Just provide all required parameters via command line.
Default working directory is `/data`.
Therefore, input data should be mounted using `/data` volume.

Running the the *Test with sample data* command from the [Manual](http://gitlab.com/ezlab/busco/raw/master/BUSCO_v3_userguide.pdf):

```
docker run --user $(id -u):$(id -g) --rm -v $PWD:/data greatfireball/ime_busco --in /opt/busco/sample_data/target.fa --out TEST --lineage_path /opt/busco/sample_data/example --mode genome
```

## Releases

The master branch contains a rolling release.
The develop branch is used for further development.
Specific tags are used for different BUSCO releases. Latest release is [![](https://images.microbadger.com/badges/version/greatfireball/ime_busco:v3.0.2.svg)](https://microbadger.com/images/greatfireball/ime_busco:v3.0.2 "Get your own version badge on microbadger.com").

| Version/Branch | Commit in Docker Repo | Image |
| -------------- | --------------------- | ----- |
| [![](https://images.microbadger.com/badges/version/greatfireball/ime_busco:master.svg)](https://microbadger.com/images/greatfireball/ime_busco:master "Get your own version badge on microbadger.com") | [![](https://images.microbadger.com/badges/commit/greatfireball/ime_busco:master.svg)](https://microbadger.com/images/greatfireball/ime_busco:master "Get your own commit badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/greatfireball/ime_busco:master.svg)](https://microbadger.com/images/greatfireball/ime_busco:master "Get your own image badge on microbadger.com") |
| [![](https://images.microbadger.com/badges/version/greatfireball/ime_busco:develop.svg)](https://microbadger.com/images/greatfireball/ime_busco:develop "Get your own version badge on microbadger.com") | [![](https://images.microbadger.com/badges/commit/greatfireball/ime_busco:develop.svg)](https://microbadger.com/images/greatfireball/ime_busco:develop "Get your own commit badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/greatfireball/ime_busco:develop.svg)](https://microbadger.com/images/greatfireball/ime_busco:develop "Get your own image badge on microbadger.com") |
| [![](https://images.microbadger.com/badges/version/greatfireball/ime_busco:v3.0.2.svg)](https://microbadger.com/images/greatfireball/ime_busco:v3.0.2 "Get your own version badge on microbadger.com") | [![](https://images.microbadger.com/badges/commit/greatfireball/ime_busco:v3.0.2.svg)](https://microbadger.com/images/greatfireball/ime_busco:v3.0.2 "Get your own commit badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/greatfireball/ime_busco:v3.0.2.svg)](https://microbadger.com/images/greatfireball/ime_busco:v3.0.2 "Get your own image badge on microbadger.com") |

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Author

- **Frank Förster** - *Initial work* - [greatfireball](https://github.com/greatfireball)

See also the list of [contributors](https://github.com/greatfireball/ime_busco/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
