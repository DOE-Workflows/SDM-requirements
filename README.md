Simulation Data Management Requirements
========================================

<!--
    This document is written in Markdown.

    To generate formatted documents from this use pandoc:

    For Word output:

    pandoc -s -S <thisfilename> -o <outname>.docx
    You can then select the lists and change the style to #.#.# to recover the nested numbering used in the original Sandia Word document.

    pandoc also allows to generate PDFs, HTML and many other output formats.

-->

## Combining input from the following laboratories:
- [Lawrence Livermore National Laboratory](https://www.llnl.gov)
- [Los Alamos National Laboratory](http://www.lanl.gov)
- [Oak Ridge National Laboratory](https://www.ornl.gov)
- [Sandia National Laboratory](http://www.sandia.gov)

## Simulation Data Management Philosophy

The Sandia Analysis Workbench philosophy is that there be a repository for all analysis information and that repository is the source of truth.  The repository serves as a version control system during development of a computational model; specific versions of artifacts can be linked together to indicate provenance, dependencies and other relationships.  The core concept is that "Everything is in the SDM." A secondary concept is that a data object should be stored in only one place.  The authors have discussed the possibility that different sites may have their own definition of 'everything' related to an analysis or simulation workflow; at Sandia "everything" tends to include digests and exclude bulk data (as defined below.)  Large scale ensembles may generate multi-terabyte data sets, and some sites may determine that such bulk data does not belong in the SDM, but in an external system designated for such data.

The experience of the deployed SDM system at Sandia is that anything that is not automatically captured is not going to get captured.  In other words, depending on users to manually capture information is a poor strategy.  A better approach is to provide users tools that improve their productivity, and as a by product capture data and relationships in an SDM system.

Finally, these requirements refer to 'files'.  While this is the basis of Posix storage and a concept easily understood by users, there is a movement in industry away from files towards broader concepts. This movement is designed to reduce cognitive load on analysts.

> **Disclaimer**

> This document was prepared as an account of work sponsored by an agency of the United States government. Neither the United States government nor Lawrence Livermore National Security, LLC, nor any of their employees makes any warranty, expressed or implied, or assumes any legal liability or responsibility for the accuracy, completeness, or usefulness of any information, apparatus, product, or process disclosed, or represents that its use would not infringe privately owned rights. Reference herein to any specific commercial product, process, or service by trade name, trademark, manufacturer, or otherwise does not necessarily constitute or imply its endorsement, recommendation, or favoring by the United States government or Lawrence Livermore National Security, LLC. The views and opinions of authors expressed herein do not necessarily state or reflect those of the United States government or Lawrence Livermore National Security, LLC, and shall not be used for advertising or product endorsement purposes.

> **Auspices Statement**
> This work performed under the auspices of the U.S. Department of Energy by Lawrence Livermore National Laboratory under Contract DE-AC52-07NA27344.

<div class="pagebreak"></div>

## Glossary

 **Workflow** an orchestrated and repeatable pattern of business activity enabled by the systematic organization of resources into processes that transform materials, provide services, or process information.

 **Computational Science Workflow** the process of simulation, experiment, and theory, by single individuals or work groups, required to complete a *campaign* or *project* and propagate/disseminate its results.

 **Simulation Workflow** The process of running an simulation or simulations, which may or may not be closely coupled, in the service of a Computational Science Workflow. In LANL parlance a workflow can be separated into distinct phases and layers.

 **Layer** a hierarchically defined subset of a Simulation workflow, layer 0 being the outer most layer (see below) encompassing the interface to the user(s), with lower/deeper layers increasingly defined by computer science and system engineering considerations (e.g., in-situ coupling)

 **Campaign Layer** (layer 0): an orchestrated set of process layer jobs, as user(s) change approach, physics, in order to complete a campaign or project.  

 **Process Layer** (layer 1) this layer interfaces with the user ('a person  who runs codes'), may involve the running of suites applications, or sets of closely coupled applications, for which the user must manage inputs, outputs and execution.  Defines and end-to-end repeatable process  (e.g., scriptable),  where the user interacts  with HPC environment, constructs code inputs, and schedules/runs analysis applications.

 **Application Layer** (layer 2): a simulation code or similar composition of packages, interacts across memory hierarchies, archival storage and data  management systems. For a simulation code the subcomponents are physics packages and their interactions with analysis and I/O.  This layer is the purview of the code developer and  third party library developer, as well as  systems software etc.

**Package Layer** (layer 3): the processing of kernels and their interaction with compute hardware, including caches, and other memory hierarchies.  In this naming convention, a task based parallel infrastructure might be considered a package layer workflow engine. Alternatively, this could be the per-core aspect of a simulation workflow.

 **Project (SNL)** Projects associate a given body of work within an hierarchical structure with a given set of team members. Projects are intended to have a specific lifetime, and a project should have an identifiable set of deliverables. Of course, projects may be used as a general storage area without the need for a time frame or specific outcome. By associating teams to projects, a project is a primary focus for access control.

 Roles:
 - team member: may create folders and artifacts in a projects
 - team lead: is team member, and may adjust team membership and add meta-groups - project lead: is team lead, and may make changes pertaining to lifecycle of the project


 Implementation:
 - projects are top level folders with special properties
 - projects are not often linked together, but often have artifacts that are stored in other projects
 - Hierarchical projects were once supported at SNL, but users did not like them.  NTK across a hierarchical project is not a solved issue.  Instead, families of related projects are used, with shared artifacts.


 **File** a collection of bytes stored in a filesystem,  object store, or content addressable store (like  git).  A single data set  might be composed of  many files.  Documents  are typically one file,  although a LateX  'document' is often built out of many source files.  

 **Data** numerical and/or categorical  information.  Data may  be used as input to simulations (e.g.,  equation of state tables), generated as output (time histories,  Silo files), produced in digest form (statistical summaries, ultra files),  contained in log files in human readable form  (e.g., time step information, indices and locations of zones with  negative sub-volumes)

 **_The size of data used as input and generated as output is widely varying, so we probably need a nomenclature for distinguishing data that might be amenable to longer term storage and index, vs. data that needs to reside on a parallel filesystem._**

 **Artifact** An artifact is a database entry or entries that represents the metadata about some  deliverable. It is basically an entry in a database that may point at one or more files,  but can also represent  an abstract thing that is not representable by a file.

 - It may have *N* files attached to it, though current Business Rules at SNL limit a single file to an artifact.
 - Any file may have *N* file versions attached. A file may be stored in the repository, or it may be a link to an external storage location.
 - Artifacts may be of various types, and each type has a set of attributes associated with it. The specific attributes associated with the artifact may be modified by the *owner* of the artifact (usually the individual who created the artifact), or a Team Lead.
 - Separation between artifacts and files allows abstract things to be represented  


 **Meta-data** Data about a simulation, including identifiers that uniquely specify  inputs that might be  hosted elsewhere.  Examples include file  paths, physics parameters, and machine and node information. *Meta-data may be a function of time (e.g., mesh management parameters for ALE).*

**Bulk-data** Large scale time histories of simulation runs, typically so large that it resides on parallel filesystems and may have limited lifetime before purging.  Examples include visualization dumps of spatially defined fields (scalars, vectors, etc.) for a large set of samples across time of the run.

**Digest** Data of smaller size    that describe the  simulation either in  aggregate, or in a  sample-based fashion.   Examples include f(t) curves (scalar quantity vs. simulation time), scalar figures of merit (integrated  values over time and/or  space), movies, reduced  models (e.g.,  statistical information,  morse theoretical structures such as contour trees), response functions from UQ analysis, and images  (e.g., simulated  diagnostics).

 **Document** A human readable form of    information that may or  may not contain data (most likely in digest  form) and may be  considered a discrete  entity. Examples:  Log  files, power point, PDF  files, **human generated  simulation input  decks/scripts,**  post-processing  scripts.  Documents will  often have relationships  to data and simulations  (data model to be  determined!)

 **Baseline** A baseline is a tagged set of files, similar to the way sets of files  can be tagged in version  control systems.  For example, baselines are  used in design  engineering to tag part files that make up an  assembly.  In modeling and simulation,  baselines can be used to  keep track of the files  associated with a model  and its simulation  results files.

 **Problem** The set of data and  documents describing the  physical characteristics  of an experiment that,  when coupled with a  model, can be used to  produce simulations of  the experiment.   Example: a shock tube  problem might consist of  the physical dimensions  of the tube and  membrane, identify the  materials involved, but not describe the physical models of those materials (EOS vs. Elastic/Plastic Strain etc.), and the characteristics of the shock generation.

 **Model** The set of data and  documents that define a  simulation. This  includes input decks,  meshes, data files,  etc..  A model can be  composed of several baselines under the  Sandia definition.   Example: starting from a  Shock tube problem  definition, the model  would consist of the  mesh specification or input script, the  material data (densities  etc.), equation of state selection, numerical  solution methods and  approaches, and other  aspects of setting up a  simulation code.

 **Model (SNL definition)** documents that specify a  particular simulation of  a problem.  That is,  mesh descriptions,  material data and other  tabular or other  specifications, simulation input  scripting and settings,  job submission  requirements (number of  nodes and domains etc).  

**_ Should we settle on common definition of model _**?

 **Suite** A collection of studies, clarify  which may include  re-runs, and may involve multiple different  simulation codes

 **Study** The collection of runs clarify whose results will be observed together.

 **Scaling Study**    

 **Parameter Study**    

 **Run** A single instance of one clarify or more simulation codes and the output for it, e.g. 1 msub / sbatch submission.  A problem combined with a model may be executed and thus generate several runs.

 **Step** A single instance of clarify something that can be executed. This does not need to be a simulation. e.g. a single \`srun\` call, calling a script

## Formulation and Structure of the Requirements

*Functional requirements describe behaviors the system shall exhibit under certain circumstances or actions the system shall let the user take, either from the system or user perspective:*
- *System perspective: "The system shall ... ", or "When ..., the system shall ...",*
- *User perpsective: The <user class or name> shall be able to <do something> to <something> subject to <response time or quality objective> *


## User Requirements (Section 3 of Word Doc)

1. The system shall allow users to commit version changes to files. This will include the following version metadata:
    - version owner
    - revision comment
    - revision date

    > Notes: This requirement is file oriented; artifacts in the system can be associated with files but do not need to be.
    > The system does not explicitly provide a capability to merge to versions of a file, but user-space tools can be provided that allow a new version of a file to be created by moving changes amongst previous versions.

2. The system shall allow users to create baselines from a collection of files (documents and/or data).  Example: the inputs and outputs of a simulation can be baselined, grouping them together and enabling them to be downloaded as a unit.
**The notes indicate that when users download a project to their local workspace, they must reference a baseline.  If they do not provide a baseline, do they get the latest revision of all the files in the project?  Can they select on a per file basis which version to synchronize to their workspace, separately from any baseline?** ** Yes, normal operation is to check out top copy, and yes, you can move individual artifacts to any available version. **

3. The system shall allow users to download all files, and only those files, associated by a given baseline.

4. The system shall allow users to version baselines.

    >Notes: Baselining is a secondary concept, and is basically the ability to group files and enable you to download them to your workstation in a particular state. The primary use-case is grouping the inputs and outputs of a simulation.  This is a separate concept from  *dependencies* between artifacts, which exist outside of baselining.

5. The system shall provide a mechanism to track provenance by allowing users or tools to create dependency links between objects (that is files and/or artifacts).  This enables expression of upstream/downstream or producer/consumer relationships in scientific workflows.  

    >Example: a user is changing an input deck over time.  Running simulations using different versions of the deck might create variants of the input mesh, or outputs, and different simulations might have run on different compute clusters. Later, a Word document is created using the results. Suppose it is discovered that version 3 of the deck contained an error, it is possible to use file dependencies to tag or label the results generated using that deck as invalid, including user derived objects like a Word document, if the user or system tracked the dependency.

    >Notes: While this sounds similar to baselines, it is a fundamentally different concept.  Baselines are collections of files that go together to represent a higher level thing.  File dependencies provide provenance metadata as to how a file came to exist.  Examples of dependency relationships include:

6. The system shall authenticate users via existing methods installed at a site.  Example: integration with Sandia's Kerberos should detect an existing ticket, should one exist, and use that to authenticate a user.
The system shall have an interface to industry standard personnel databases such as LDAP

7. The system shall enforce *Need to Know* (NTK) restrictions on files, as defined by project leads and system administrators

8. The system shall enforce classification restrictions on files.  

    >Example: a project may have a larger NTK group, to include potential reviewers and/or managers, but some files in the project may be restricted.  This allows project reviewers to see the parts of the project relevant to them using fold NTK settings and protecting some information via per-file NTK.

    >Notes: it is an important business use-case that NTK be tracked on a per-file basis.  In the past, this requirement precluded Windchill as back-end, though this may have changed.

9. The system shall allow users to browse projects that they have access to and enable access to project contents and subdirectories.

    >Notes: when a user checks out a project, they get a folder hierarchy in their workspace.  A project can contain links to other projects but those links don't necessarily get downloaded.

10. The system shall allow search based on file names

11. The system shall allow search based on file contents

12. The system shall allow search based on meta-data, including document type,  owner, document attributes as defined later, and custom user-specified attributes

13. The system shall enforce NTK restrictions on search results.  Results must be filtered on the server, not the client.

    >Notes: how the search results are displayed must be handled carefully. Displaying that a results exists, but has been omitted may violate NTK.  Associating an author with a document may also violate NTK restrictions.

14. The system shall allow documents to be referenced via URL that can be pasted into other applications and documents (e.g., Word, Powerpoint, webpages)

    >Notes: this allows the system to connect to other systems and to federate resources.  In the current SNL implementation, the URL points to an artifact, which can be used to retrieve the file.  Github implements this feature and would be a good place to get ideas on implementation.

15. The system shall track the following document meta-data:
    - classification level that can be used to adjudicate NTK, with specific tags to be agreed upon by stakeholders to facilitate document transfer between sites
    - engineering notes: user definable notes stored and versioned with documents
    - standard attributes such as file type, size, creation date, mod date, MD5 check sum, etc.
    - user defined attributes: arbitrary name-value pairs defined by users

16. The system shall provide an Eclipse RCP interface composed of a set of plugins that can integrate into SAW as the Project Navigator.  This is the primary SNL interface for analysts as they perform work and contribute content to a project.

17. The system shall provide a command line interface to all capabilities exposed through other interfaces

18. The system shall provide a web interface to allow users to access documents via a web browser without having to install client software. This interface will be useful for sharing information with content consumers such as managers and analyst's customers more so than content providers

    >Notes: a REST interface is preferred in general, but may impose restrictions that would make Eclipse integration harder, so some followup on tightening this requirement may be needed.

19. The system shall allow users to create ensembles or suites of runs with meta-data common to each member of the ensemble or suite.  The system should explicitly store dependencies between the suite inputs and outputs such as tabulated data of inputs and outputs of the study,  meta-data, and the generated simulation data.  File size may vary from 10's of bytes to 10^7 bytes.  **Discussion questions: should we allow the SDM to have references to files in transient file systems?  Should we enable server side analysis?**

    >Notes: current practice is that this is not tracked in the SDM system directly, but instead managed by SAW. A motivation for first class representation of ensembles is to enable server-side analysis and visualization of ensembles, without requiring them to be downloaded.  Under the existing SNL SDM system, this is not supported.

20. The system shall allow users to move *bulk data* between long term storage and their workspace. This is in contrast to data that is in the SDM system which should never be lost. **This requires a discussion on how the system should handle links to external files, and how to check the validity of those links.  LANL and LLNL feel this will be a need in their environments.***

    >Example: a user runs a simulation.  The non-bulk data is stored in the SDM system, but the bulk data, such as visualization dumps of mesh-based fields at a large numer of timesteps is not.  The bulk data is on a scratch parallel filesystem subject to purging.  The system should allow users to copy this data to long term tape backup, and store a URL or other unique reference to the data in the SDM, such that it can be brought back from tape to the parallel filesystem in the future.

21. The system shall allow URL or other unique ID's to be used to refer to data stored in other systems, allowing federation across multiple data stores.

22. The system shall allow data migration

23. The system shall be backed up and fully restorable.  It shall be part of the disaster recovery plan.


## Functional Requirements (Section 4 of Word Doc)

1. **Project actions**


    1. The system shall organize all information into projects, which will associate a given set of files and folders with a set of users ('the team members'). A project is in essence a top-level folder in the system with additional properties and behaviors.

    >Notes: projects are the fundamental basis of access control. The existing system also has *meta-groups* for additional access control.  A project can contain an arbitrary tree of folders with their own permissions and access controls.

    2. **(NEW)** Projects may be nested within projects.  In a nested projects, project roles are the union of all parent projects.  NTK requirements are inherited from parent projects but may be overridden (the same behavior as for folder hierarchies.

    >Notes: hierarchical projects allow for a greater amount of sharing amongst projects by default, vs. the approach in the current system in which artifacts are the vehicle by which projects can share files.

    3. The system shall support policies that can be used to restrict project structure or apply per-site business rules.  For example, a site may determine that nested projects shall not be allowed.

    4. The system shall track project members and allow them to create artifacts in the project.

    5. The system shall track project leaders, and allow them add or remove project members, either individually, or via access control lists or Unix groups.  All project leaders are project members.

    6. The system shall track project managers, and allow them to modify the project with respect to its lifecycle, assign new project leader, and transfer the project manager role to another user, as well as project attributes, including: Project name and description, deliverables, classification and modifiers, analysis discipline (SNL specific), responsible manager **(not project manager?)**, start, estimated finish, actual finish

    7. the system shall allow tracking and tagging of project deliverables, which are files identified by the project lead or project manager

    8. The system shall allow any authenticated user to create a project. By default the creator will have all three roles (member, lead, manager).

    9. The system shall allow tracking of the project lifecycle.  During the lifecycle, different access permissions are available and team composition may change.

    10. The system shall allow modification of project attributes by the team lead.  Limitations on this ability and the list of attributes that a project lead may change are **to be determined**.  Business rules may prohibit some changes, such as classification level changes.  For example, lowering the classification level when a project contains files at a high level.

    **Discussion:** the general consensus is that the system should allow flexible project structures, and implement restrictions through policies.  It was noted that open science users may not want to adopt a system that enforces a certain structure for projects.  Some sites may not need rigid NTK rules and thus may allow much freer project structures.  NTK is complex, and in the current system implemented at the object level.  Every artifact has a policy associated with it.  This complexity may drive some project structures in order to insure compliance with NTK requirements, that are not required in the open science domain.  Finally, it was noted that some sites may elect to deploy multiple systems tailored for particular sub-communities of users, rather than attempt to install a single SDM across the site.

2. **Folder Actions**

    Note: the term 'folder' implicitly includes the project, as that is simply a folder with additional semantics as detailed previously.  Folders are typically the unit of 'use' at SNL.  Users tend to pull only a subset of folders in a project to their workspace.

    1. The system shall allow any project member to create a folder at any level in the project hierarchy.  Folders can contain artifacts or other folders.  The top level project is a specialized folder with additional attributes

    2. The system shall allow any team member of a project to add an artifact to a folder in that project.

    3. The system shall allow users to add artifacts to folders.  Artifacts may be linked across projects subject to NTK business rules

    4. The system shall allow a team member of a project to remove a folder from a folder in that project, subject to folder locking.  Recursive contents must be handled according to business rules.

    5. The system shall allow a team member of a project to remove an artifact from a folder.  This does not imply deletion of the artifact, merely the disassociation of the artifact from that folder and thus the project.  The artifact may still be linked to multiple parent folders or in other projects.  Business rules or a locked folder may prevent this action.

    6. The system shall allow a member of a project to delete a folder in that project.  Business rules determine how folder contents are handled.  Some artifacts may be deleted if they are not referenced elsewhere and some may merely be detached from a folder prior to its deletion

    7. The system shall allow the owner or any team lead of a project to modify the attributes of a folder. Business rules may prohibit certain modifications such as raising a folder's classification level higher than a parent folder.  The name of a folder is considered an attribute.

    8. The system shall allow any team lead of a project to adjust the sharing of a folder by applying a group to the folder.  Such sharing is an NTK operation.  Artifacts present in the folder shall have there visibility adjusted. New artifacts added to a folder shall have the visibility associated with the new scoping

    9. The system shall allow any team member of a project to register for notifications when changes are made to a folder in the project.  Changes include adding/removing children (other folders or artifacts).

3. Artifact Actions  **TO BE DISCUSSED**

    1. **Create Artifact**: any Team Member may create an artifact in a folder. 

    2. **Add File Version to Artifact**: Assuming the artifact is not locked to a specific individual, any Team Member may commit a new version of a file to an artifact.

    3. **Add Artifact To Folder**: Within the same project, any Team Member may add an artifact to any project. An artifact may have multiple parent folders (i.e, it may be linked in multiple places), but exists as a single object. Adding an artifact to a folder in a different project may be restricted due to NTK Business Rules. When an artifact is added to a folder, Business Rules are processed to ensure compliance with certain situations. An example of a Business Rule is that an artifact cannot be added to a folder with a lower classification. When an artifact is added to a folder, Business Rules may automatically apply certain default settings (e.g., classification).

    4.	**Update Artifact Attributes:** An artifact owner or any Team Lead may modify any attribute of an artifact. Artifacts have a type, and each type has specific attributes.

    5.	**Move Artifact to Another Folder:** Any Team Member may move an artifact between folders within the same project. This capability is needed to support refactoring.

    6.	**Modify Artifact Lifecycle State:** Artifacts have an associated Lifecycle. The owneror a Team Lead may modify the Lifecycle state of an artifact. The operations permitted against an artifact may differ by lifecycle state. The particular states and access permissions are definable by the type of the artifact. Modifying the Lifecycle state collects an electronic signature and optional comments. Business Rules may prohibit certain transitions. Additional Business Rules may be invoked upon a transition (such as keeping only the latest file version).

    7.	**Delete File Version(s)**: The artifact owner or any Team Lead may delete specific versions of a file attached to an artifact.

    8.	**Delete Artifact:** The artifact owner or any Team Lead may delete an artifact. Deleting an artifact removes it from all parent folders, removes all files and file versions from the file storage location (note: externally referenced files are not affected), and the artifact metadata is deleted. A history notation about an artifact deletion should be available.

    9.	**Search for Artifact by Attributes**: An artifact may be found by searching for values on any of its attributes. All search results are constrained on the server to match only authorized results. Note that searching by full text in a file attached to an artifact should also be supported, but the returned Artifacts must be filtered on the server as well.

    10. **Specify Access Control on an Artifact (e.g., group or role):** Artifacts, by default, are visible only within the context of a project, and thus limited to the team. Access may be reduced to only the Object Owner, or may be expanded by associating other groups with the artifact.

    11. **Change Owner of an Artifact:** The current owner or any Team Lead may change the ownership of an artifact. Artifact ownership has certain NTK responsibilites associated with it, and in some cases an owner may perform actions (such as locking for modification).

    12. **Relate Artifact to another Artifact:** An artifact may be related to another artifact. For example, there may be an artifact type of "Engineering Note" that may be related an artifact type of "Analysis Artifact". The specific relationship type determines the cardinality and directionality of any relationship, and specific relationships may carry particular attributes as well. The state of an artifact may prevent certain associations, and other Business Rules may also be applicable.

    13. **Lock to prevent modifications:** An owner or a Team Lead may lock an artifact to prevent modifications. The attributes on a locked artifact may only be modified by the locker, and only the locker may add new file versions to the artifact. The locked status does not affect viewing the artifact or downloading files (subject to other access control issues). Any Team Lead may remove a lock on an artifact.

    14. **Register for Notifications**: Any Team Member may register for notifications about changes to an artifact. One may register for notifications about new files or file versions added, if the artifact is added to a folder (moved or linked to an additional one), when it is locked or unlocked for modifications/file commits, or when attributes are modified.

4. Team Actions 

    1.	**Add Person to Team:** Any Team Lead may add an individual to the project team. Adding a Team Member is inherently an NTK decision. Any registered user may be added to the team. Business Rules may prohibit certain additions depending upon project attributes (e.g., classification).

    2.	**Change Role of Person On Team:** Any Team Lead may modify the role of a person on the team. An individual may be changed from a Team Member to a Team Lead or the Project Manager. An individual may be changed from a Team Lead to a Team Member. Changing the role affects certain access permissions, as well as the ability to change team membership and participate in artifact sharing (a form of NTK).

    3.	**Remove Person from Team:** Any Team Lead may remove an Team Lead or Team Member from a Project. The Project Manager may not be directly removed from the team, but instead a new Project Manager must be assigned, and then the previous Project Manager (who will now be a Team Lead)  may be removed.

5. History Actions 

    1.	**Automatic History:** Most activities (e.g., adding an artifact, committing a file version to an artifact, modifying attributes, etc.) automatically generate a history entry. History entries must be relatable to the user, the time of the action, and the specific object.

    2.	**Add User Defined History Entry:** It must be possible to add User Defined history to an Object. That is, history entry types must not be limited only to system generated entries.

    3.	**Obtain History for an Object:** For any Object, it must be possible to obtain the history entries relating to that object.


## Technical Requirements (Section 5 of SNL Word Document)

1.	Open Interface

    1. Must be possible to integrate with or provide bindings for: Java, Python, and C

2.	Licensing

    1.	Must be possible to deploy with no license encumbrance

    2. The reference implementation will not be built on an infectious license or proprietary technology

3.	Transaction Management

    1. Write and update transactions are required.  Reason: many operations have multiple steps, and must have transaction support

    2. Read transactions are preferred but not required.

    3. ACID Compliance is preferred

4.	Ability to define Attributes
    > Note: the intent of these requirements is to constrain the possible low level systems upon which the SDM system is based.

    1.	Type (e.g., String, float, etc.)

    2.	Default Values

5.	Ability to define various "types" of objects
    > Example: an adminstrator may want to define a 'mesh' type, to enable searching for meshes.

    1.	Collection of attributes

    2.	Hierarchical and inheritable

    3.	Optionally used in search, to enable restricting a search using something other than keywords

6.	Ability to separate data into different shards/tablespaces based upon type or controllering workflow.
    >Example: E-Matrix currently stores files in a filestore, and references them in SQL database entries.  The database knows which filestore the data is stored, and what kind of filestore it is.

7.	File Storage

    1.	External to the metadata management

    2.	Must support:

            1.	Stored files
            2.	External references to files
            3.	Individual files up to 2GB in size **NEED TO NAIL THIS NUMBER DOWN**
            4.	Progress Monitoring on file upload/download
            5.   Per-site policies on allowed data sizes

    3.	File Versioning

    4.	A File Version must exist as an object that may be related (e.g., baselining).
        > Note: this is required for tracibility/provenance and also to enable URLs to specific versions of files.  That is, the system must allow links to the versioning object so that the corresponding file can be reconstructed or retrieved.

8.	Index-based Search

    1.	Attribute based for selecting metadata

    2.	Full file text search

    3.	Must respect the per-site security model, which can be expressed on a per-object basis.  That is, every object has a policy.

9.	Flexible Authentication mechanisms

    1. a pluggable single sign-on authentication mechanism that allows methods like Kerberos to be integrated.
        >Note: sites must do ticket management properly or they will not be forwardable.

10.	Authorization (permission to do operations like read/write/copy/deleted)

    1.	Be object-level based
    2.	Support object attributes for authorization adjudication
    3.	Support custom modules for extending the authorization model
    4.	Must be handled on the server (i.e., never return to the client data that is inappropriate)
    5.    Must be specified through policies that can be customized for each site / installation

11.	Access Controls
    1. must be based on persons, groups, and roles, and multiples of these.
        > Note: supporting multiples removes the need to create artifical groups when more than one group needs access.  This means that when a folder is brought to a filesystem, the actual unix group can only be one of the groups in the multiple.  Meta-groups an solve this, but it leads to large numbers of groups.
    2. groups and roles are collections of access controls
    3. RBAC alone is insufficient
    4. Must allow boolean combinations (groupA or groupB and groupC)
    5. Must be able to prevent "owner" from having access
        >Note: this is to handle the case when the owner loses the authorization to access the data for some reason.

12.	Extensible Trigger System
    > Note: this is a requirement on the base-system to provide hooks that allow events to be triggered when actions occur, such as a database update or file version update.

    1.	Type based or attribute based. **NEED TO ELABORATE ON THIS**

    2.	Event driven for multiple event types (pre/override/post on various events such as create/update attribute/delete/etc.)

13.	Ability to "subscribe" to various object events

    1.	Notification when certain object events occur, such as adding a file, changing the owner, etc.

14.	(Proposed OPTIONAL Requirement) Lifecycle states

    1.	Ability to define different lifecycles

    2.	Apply these lifecycles to the objects

    3.	Access control must be tied to lifecycle state

    >Discussion: these requirements generated a lot of discussion,  define lifecycles

15.	Administrative Console 
    1. Allows you to operate with objects that exist in the database
    2. Command line access

16.	Unique Object Reference (i.e., an Object Identifier)

    1.	Must be stable
    2.	Must not be tied to a display attribute that can change
    3.  Identical objects can have different ids
    4.  Support for content-based hashing as an additional add-on
        capabilty would be preferred

17.	History entries created automatically by various activities
    1.	Ability to add custom history entries
    2.	History must tie to particular objects (**DEFINE "OBJECT" HERE?**)
    3.  Compliance with ISO standards (9000, 27001, 27002) for auditability
    4.  Specific list of activities to come later

18.	Relationships between objects can be defined and have the following properties:
    1.	Attributes on relationships
    2.	Cardinality (number of objects in a relationship)
    3.	Type limited
    4.	Direction (to/from based upon object type)
    5.	Ability to use in traversal
    6.	Participate in the Trigger system

19.	Ability to lock an object to prevent updates and/or file additions
    

20.	Robust Permission Model
    1.	Create
    2.	Read Attributes
    3.	Update Attributes
    4.	Delete
    5.	Relate to a Parent Object
    6.	Relate to a Child Object
    7.	Remove Relationship
    8.	Add File Version
    9.	Remove File Version
    10.	Download File Version
    11. Create Copy
