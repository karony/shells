专业术语说明：

	1. 安全认证 Sercurity Credentials：
		Console Password：文本密码，用于用户登录页面登录，密码由管理员分配。
		API Signing Key：使用非对称密钥认证，例如使用bash远程控制时就是使用。
		Instance SSH Key：创建的虚拟机实例，我们连接使用的SSH密钥登录。
		Swift Password：用于Swift客户端访问对象存储。

	2. Regions and Availability Domains
		Regins：
			本地区域，对应着指定的物理区域，Oracle目前有3个Regions，下面显示了各regions的地理位置，名字以及对应的key

			Region Location 	            Region Name 	Region Key
			Phoenix, AZ metropolitan area 	us-phoenix-1 	PHX
			Ashburn, VA 	                us-ashburn-1 	IAD
			Frankfurt, Germany 	            eu-frankfurt-1 	FRA
			
		Availability Domain：
			所有的Domains都会属于一个Region，各个域使用的不同的物理设备，具有容错性。

			Most bare metal resources are either region-specific, such as a virtual cloud network, or Availability Domain-specific, 
			such as a compute instance.

		Resource Locations：
			下面为个资源作用的访问
			Resource       	                    Location 	           Notes
			API                                 signing keys 	       Global 	 
			Buckets 	                        Region 	               Although a bucket is a regional resource, it can be accessed from any location as long as you use the correct region-specific Object Storage URL for the API calls.
			Compartments 	                    Global 	 
			Customer-Premises Equipment (CPE) 	Region 	 
			DB Systems 	                        Availability Domain 	 
			DHCP options 	                    Region 	 
			Dynamic routing gateways (DRGs) 	Region 	 
			Groups 	                            Global 	 
			Images 	                            Region 	 
			Instances 	                        Availability Domain 	Instances can be attached only to volumes in the same Availability Domain.
			Internet gateways 	                Region 	 
			Load Balancers 	                    Region 	 
			Policies 	                        Global 	 
			Route tables 	                    Region 	 
			Security lists 	                    Region 	 
			Subnets 	                        Availability Domain 	 
			Users 	                            Global 	 
			Virtual cloud networks (VCNs) 	    Region 	 
			Volumes 	                        Availability Domain 	Volumes can be attached only to an instance in the same Availability Domain.
			Volume backups 	                    Region 	                Volume backups can be restored as new volumes to any Availability Domain within the same region they are stored.



	3. Resource Identifiers
		介绍Oracle Cloud Infrastructure（OCI）资源表示的各种方式。

		Oracle Cloud IDs (OCIDs)：
			每一个Oracle Cloud Infrastructure Resource（Oracle云基础设施资源）Oracle都会在创建时分配是个独一无二的ID，
			我们称这个ID为Oracle Cloud Identify（OCID）。

			OCID的语法：
				ocid1.<RESOURCE TYPE>.<REALM>.[REGION][.FUTURE USE].<UNIQUE ID>

				    ocid1: OCID的版本号.
				    resource type: 资源类型 (for example, instance, volume, vcn, subnet, user, group, and so on).
				    realm: The realm the resource is in. A realm is a set of regions that share entities. The only possible value is oc1.
				    region: 资源所在的Rigions (for example, phx, iad, eu-frankfurt-1). With the introduction of the Frankfurt region, the format switched from a three-character code to a longer string. This part is present in the OCID only for regional resources or those specific to a single Availability Domain. If the region is not applicable to the resource, this part might be blank (see the example tenancy ID below).
				    future use: Reserved for future use; currently blank.
				    unique ID: The unique portion of the ID. The format may vary depending on the type of resource or service.

				    示例：			    	
					    tenancy: ocid1.tenancy.oc1..aaaaaaaaba3pv6wkcr4jqae5f44n2b2m2yt2j6rx32uzr4h25vqstifsfdsq
					    instance: ocid1.instance.oc1.phx.abuw4ljrlsfiqw6vzzxb43vyypt4pkodawglp3wqxjqofakrwvou52gb6s5a
			OCID在何处：
				我们使用OCI API接口时，会用到OCID，一些IAM 操作时也会使用到tenancy ID。
				OCID可以在页面下方看到OCID，注意tenancy标识。
				示例：ocid1.tenancy.oc1..aaaaaaaaba3pv6wkcr4jqae5f44n2b2m2yt2j6rx32uzr4h25vqstifsfdsq

		Name and Description (IAM Only)
			The IAM service requires you to assign a unique, unchangeable name to each of your IAM resources (users, groups, policies, and compartments).
			The name must be unique within the scope of the type of resource (for example, you can only have one user with the name BobSmith). 
			Notice that this requirement is specific to IAM and not the other services

			The name you assign to a user at creation is their login for the Console

			You can use these names instead of the OCID when writing a policy 

			除了名字之外，你还可以为你的IAM资源分配一个描述字符串，但也可以为空。

		Display Name
			我们在Oracle云基础设施的资源除了一些在IAM中的，都可以设置一个显示名字。用于方便了解到资源的作用，不要求唯一，可随时改变。
			The Console shows the resource's display name along with its OCID。

	4. Service Limits
		This topic describes the service limits for Oracle Cloud Infrastructure and the process for requesting a service limit increase

		About Service Limits
			在我们使用Oracle Cloud Infrastructure时，各个服务都会有其默认设置。例如，每一个可用Domain使用Compute Instance会有一个最大数。

		What Happens When I Reach a Service Limit?
			When you reach the service limit for a resource, you will receive an error when you try to create a new resource of that type
			ou cannot create a new resource until you are granted an increase to your service limit or you terminate an existing resource. 
			Note that service limits apply to a specific scope, and when the service limit in one scope is reached you may still have resources available 
			to you in other scopes (for example, other Availability Domains). 

		Requesting a Service Limit Increase
		    1. Go to My Oracle Support and sign in.
				If you are not signed in directly to Oracle Cloud Support, click Switch to Cloud Support at the top of the page.
		    2. Click Service Requests.
		    3. Click Create Service Request.
		    4. Select the following:
		        Service Type: Oracle Compute Cloud Service Bare Metal
		        Service Name: IAASMB IAASMB
		        Problem Type: Request limit increase
		    5. Enter your contact information.
		    6. Enter a Description, and then enter the following specific information:
		        Tenancy OCID		        
		        The service or resource that you are requesting the service limit increase for.
		        For example: Request increase in limit for 256 GB block volumes.
		        Requested limit increase.
		        For example: Increase the service limit to 10 volumes.
		        Reason for the request. Describe what you are trying to accomplish with the increase.

		Limits by Service
			Block Volume Limits：
				Resource                        Monthly Universal Credits   Pay-As-You-Go
				Block Volumes aggregated size 	10 TB 	                    3 TB
				Backups 	                    100 	                    20

			https://docs.us-phoenix-1.oraclecloud.com/Content/General/Concepts/servicelimits.htm

	4. 说明：
		Understanding Compartments：
			After you select a service, you'll notice the compartments list on the left。

			Compartments help you organize resources to make it easier to control access to them。
			Your root compartment is created for you by Oracle when your tenancy is provisioned。

			After you select a compartment, the Console displays only the resources in that compartment for the region you are in. 
			The compartment selection filters the view of your resources. 
			To see resources in another compartment, you must switch to that compartment.
