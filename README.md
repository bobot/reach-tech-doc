[![Build Status](https://drone.apps.deustotech.eu/api/badges/REACH-Incubator/reach-tech-doc/status.svg)](https://drone.apps.deustotech.eu/REACH-Incubator/reach-tech-doc)

# REACH project technical documentation

This repository hosts the documentation about the different computation infraestructures, a.k.a. the Big Data Stack, offered by REACH project. The documentation is hosted at https://docs.reach-incubator.eu (TBD).

If this is your first time using [Spinx](https://www.sphinx-doc.org/),we encourage to read the [reStructured Primer](https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html) documentation. In addition, if this is your first time using git, you should read the [git manual](https://git-scm.com/docs/user-manual).

Next, how to add inputs to the documentation is explained.

## Adding inputs to the documentation

There are two different ways to add new content to the documentation:

* From the GitHub web interface (online).
* Cloning the repository to your computer (local).

In both ways, you **must create a new branch** for adding your contributions. Pushing contents directly into the `main` branch is disabled.

Every time a new branch is pushed into the repository, a new deployment is created at `http://<your-branch-name>.docs.reach.apps.deustotech.eu`.

The source files of the documentation are located at the `source` folder at the repository root.

### Using the GitHub web interface

From inside the `source` folder, you can click on the `Add file` button at the top right, in order to create or upload a new file. Notice that, if you want to create a new folder you should write the entire folder structure in which your file will be created.

![Creating new file](https://i.imgur.com/SRx8MDZ.png)

Rembember that all Sphinx files must have the `.rst` extension. 

![Writing your content](https://i.imgur.com/PNYKaX3.png)

Once you have edited or uploaded your new file, you have to commit it. To do that, there is a form at the bottom of the page.

![Commit the changes](https://i.imgur.com/VJ1PLRR.png)

As you can see, you are not allowed to push directly into main, and you have to create a new branch. Select a proper name for your branch and click on `Commit new file` button.

The worflow drives you to create a new `Pull Request` (PR). A PR is a request to integrate your changes into the `main` branch. If you have finished adding new content, you can create a PR. If you want to edit more files into your new branch, you can skip this window.

![Create a Pull Request](https://i.imgur.com/swZcXTR.png)

If instead of merging your changes into the `main` branch you want to continue editing more files in your branch, click on `Code` tab and select your branch from the drop-down list.

![Selecting your file](https://i.imgur.com/nM9dGnX.png)

### Editing your documentation locally

To edit your documentation locally, first you must clone the repository:

```
$ git clone https://github.com/REACH-Incubator/reach-tech-doc
```

Before starting to edit the documentation, you must create a new branch, as the `main` branch is protected.

```
$ git checkout -b my-branch
```

Once you have edited the documentation and commited your changes locally, you could push them into the repository.

```
$ git push origin my-branch
```

## Checking your build

Every time a branch is pushed into the repository, a new deployment is created at `http://<your-branch-name>.docs.reach.apps.deustotech.eu`. You can check how your build is going at the `Commits` section.

![Accessing to your commits](https://i.imgur.com/mubbeJQ.png)

From here, you can click at the check mark (if the documentation has been built sucessfully), the cross mark (if not) or the yellow dot (the build is running).

![List your commits](https://i.imgur.com/DF92hrG.png)

If you click on `Details`, you will be redirected to the Continuos Integration/Continuos Deployment pipeline. Here, you can check if the compilation of your documentation has failed or has success.

![Drone](https://i.imgur.com/Diwm27V.png)

If your build has finished succesfully, you can check the URL of your deployment at the last step (`service`).

## Integrating your branch into main

To integrate your changes into the `main` branch, you must create a Pull Request (PR). For that, you must navigate into the `Pull requests` tab and click into `New pull request` button.

![Pull Request](https://i.imgur.com/3pWw5FW.png)

Here, you can select your branch, at the right side of the arrow, and the main branch at the left side. Click on `Create pull request` to advance to the next step.

![Create Pull Request](https://i.imgur.com/5Bt2mzw.png)

Here you can add comments to your PR, and assign labels or reviewers (all those fields are optional). When you are done, you can create your PR.

![Create PR](https://i.imgur.com/Z6Dc9XJ.png)

Next, the status checks are executed. You cannot merge your PR until those checks are executed succesfully. You can check the run of those checks clickin on the `Details` link.

![Status check](https://i.imgur.com/3PllwmD.png)

If the status checks finished successfully, you can merge your PR clicking on `Merge pull request`. Once the PR is merged, your deployment is destroyed, so the URL `http://<your-branch-name>.docs.reach.apps.deustotech.eu` is not available anymore. If you push new commits into the same branch, the deployment is created again.

![Merged PR](https://i.imgur.com/4KiPB4g.png)

After merging the PR, your changes will be available at `https://docs.reach-incubator.eu` (TDB).