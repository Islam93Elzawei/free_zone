<?php

namespace App\Http\Middleware;

use Illuminate\Http\Middleware\TrustProxies as Middleware;
use Illuminate\Http\Request;

class TrustProxies extends Middleware
{
    /**
     * The trusted proxies for this application.
     *
     * @var array<int, string>|string|null
     */
    protected $proxies;

    /**
     * The headers that should be used to detect proxies.
     *
     * @var int
     */
    protected $headers =
        Request::HEADER_X_FORWARDED_FOR |
        Request::HEADER_X_FORWARDED_HOST |
        Request::HEADER_X_FORWARDED_PORT |
        Request::HEADER_X_FORWARDED_PROTO |
        Request::HEADER_X_FORWARDED_AWS_ELB;

	/**
	 * The headers that should be used to detect proxies.
	 * 
	 * @return int
	 */
	public function getHeaders() {
		return $this->headers;
	}
	
	/**
	 * The headers that should be used to detect proxies.
	 * 
	 * @param int $headers The headers that should be used to detect proxies.
	 * @return self
	 */
	public function setHeaders($headers): self {
		$this->headers = $headers;
		return $this;
	}
}
